#!/usr/bin/env python3
"""
build.py - Cross-platform APK & IPA builder and packager for Antigravity for Phone.
Works on Windows, Linux, and macOS without requiring Gradle.

Usage:
  python build.py                  # Build standard release (dist/antigravity.apk)
  python build.py --region-bypass  # Build region-bypass release (dist/antigravity-region-bypass.apk)
  python build.py --ios            # Build iOS & iPadOS package (dist/antigravity.ipa)
  python build.py --all            # Build all editions (Android APKs + iOS IPA) and SHA256SUMS.txt
"""

import sys
import os
import shutil
import subprocess
import zipfile
import hashlib
from pathlib import Path

PROJECT_ROOT = os.path.dirname(os.path.abspath(__file__))
BUILD_DIR = os.path.join(PROJECT_ROOT, "build")
DIST_DIR = os.path.join(PROJECT_ROOT, "dist")
APP_DIR = os.path.join(PROJECT_ROOT, "app")
TOOLS_DIR = os.path.join(PROJECT_ROOT, "tools")
MODULES_DIR = os.path.join(PROJECT_ROOT, "modules")
IOS_DIR = os.path.join(PROJECT_ROOT, "ios")

if MODULES_DIR not in sys.path:
    sys.path.insert(0, MODULES_DIR)
if IOS_DIR not in sys.path:
    sys.path.insert(0, IOS_DIR)

from runner import prepare_runtime
import build_ipa


def find_build_tool(tool_name):
    # 1. Check PATH
    found = shutil.which(tool_name)
    if found:
        return found

    # 2. Check Android SDK build-tools on Windows / Linux / Mac
    possible_roots = []
    if "ANDROID_HOME" in os.environ:
        possible_roots.append(os.environ["ANDROID_HOME"])
    if "ANDROID_SDK_ROOT" in os.environ:
        possible_roots.append(os.environ["ANDROID_SDK_ROOT"])
    if sys.platform == "win32":
        local_app_data = os.environ.get("LOCALAPPDATA", "")
        if local_app_data:
            possible_roots.append(os.path.join(local_app_data, "Android", "Sdk"))

    exts = [".exe", ".bat", ""] if sys.platform == "win32" else [""]
    for sdk_root in possible_roots:
        bt_dir = os.path.join(sdk_root, "build-tools")
        if os.path.isdir(bt_dir):
            versions = sorted(os.listdir(bt_dir), reverse=True)
            for v in versions:
                for ext in exts:
                    candidate = os.path.join(bt_dir, v, tool_name + ext)
                    if os.path.isfile(candidate):
                        return candidate

    return None


def ensure_tools():
    tools = {}
    for name in ["aapt", "javac", "java", "apksigner"]:
        p = find_build_tool(name)
        if not p:
            raise RuntimeError(f"Missing required build tool: {name}. Please install or set PATH / ANDROID_HOME.")
        tools[name] = p
    return tools


def clean_build():
    os.makedirs(BUILD_DIR, exist_ok=True)
    os.makedirs(DIST_DIR, exist_ok=True)
    for sub in ["gen", "res", "obj", "dex", "staging"]:
        p = os.path.join(BUILD_DIR, sub)
        if os.path.exists(p):
            shutil.rmtree(p)
        os.makedirs(p, exist_ok=True)
    for f in ["unaligned.apk", "aligned.apk"]:
        p = os.path.join(BUILD_DIR, f)
        if os.path.exists(p):
            os.remove(p)


def ensure_env_dist():
    env_src = os.path.join(PROJECT_ROOT, "env", "dist", "env")
    manifest_file = os.path.join(env_src, "manifest.json")
    if not os.path.isfile(manifest_file):
        print("[*] Packing env workspace into env/dist/env...")
        os.makedirs(os.path.join(env_src, "bootstrap"), exist_ok=True)
        shutil.copytree(os.path.join(PROJECT_ROOT, "env", "pkg"), os.path.join(env_src, "pkg"), dirs_exist_ok=True)
        shutil.copytree(os.path.join(PROJECT_ROOT, "env", "overlay"), os.path.join(env_src, "overlay"), dirs_exist_ok=True)
        shutil.copy2(os.path.join(PROJECT_ROOT, "env", "bootstrap", "bootstrap.tar.gz"),
                     os.path.join(env_src, "bootstrap", "bootstrap.tar.gz"))
        seed = os.path.join(PROJECT_ROOT, "env", "seed-packages.txt")
        if os.path.isfile(seed):
            shutil.copy2(seed, os.path.join(env_src, "seed-packages.txt"))
        subprocess.check_call([sys.executable, os.path.join(PROJECT_ROOT, "env", "scripts", "make_manifest.py"), env_src])
        print("[OK] Packaged env workspace.")


def ensure_web_bundles():
    web_dir = os.path.join(PROJECT_ROOT, "web")
    gen_main = os.path.join(web_dir, "generated", "main.js")
    if not os.path.isfile(gen_main):
        print("[*] Building web bundles...")
        bash_bin = shutil.which("bash")
        if sys.platform == "win32" and os.path.isfile(r"C:\Program Files\Git\bin\bash.exe"):
            bash_bin = r"C:\Program Files\Git\bin\bash.exe"
        if not bash_bin:
            raise RuntimeError("Bash is required to build web bundles for the first time.")
        subprocess.check_call([bash_bin, os.path.join(web_dir, "build.sh")], cwd=PROJECT_ROOT)
        print("[OK] Generated web bundles.")


def build_edition(tools, no_bypass=False, out_apk=None):
    edition_name = "STANDARD RELEASE (original gates)" if no_bypass else "REGION BYPASS RELEASE (account check bypass)"
    if not out_apk:
        out_apk = os.path.join(DIST_DIR, "antigravity.apk" if no_bypass else "antigravity-region-bypass.apk")

    print("\n" + "=" * 60)
    print(f"  BUILDING: {edition_name}")
    print(f"  OUTPUT  : {out_apk}")
    print("=" * 60)

    clean_build()
    ensure_env_dist()
    ensure_web_bundles()

    # Phase 01: Gen config
    print("\n>>> [1/8] Generating Configs...")
    subprocess.check_call([sys.executable, os.path.join(MODULES_DIR, "builder", "01_gen_config.py"), BUILD_DIR])
    target_manifest = os.path.join(BUILD_DIR, "AndroidManifest.xml")

    # Phase 02: Generate R.java
    print("\n>>> [2/8] Generating R.java (aapt)...")
    gen_dir = os.path.join(BUILD_DIR, "gen")
    res_dir = os.path.join(APP_DIR, "src", "main", "res")
    build_res = os.path.join(BUILD_DIR, "res")
    android_jar = os.path.join(TOOLS_DIR, "android.jar")
    aapt_cmd = [
        tools["aapt"], "package", "-f", "-m",
        "-J", gen_dir,
        "-M", target_manifest,
        "-S", build_res,
        "-S", res_dir,
        "--auto-add-overlay",
        "-I", android_jar
    ]
    subprocess.check_call(aapt_cmd)
    print(f"[OK] R.java generated in {gen_dir}")

    # Phase 03: Compile Java Sources
    print("\n>>> [3/8] Compiling Java Sources (javac)...")
    obj_dir = os.path.join(BUILD_DIR, "obj")
    sources = []
    for search_dir in [os.path.join(APP_DIR, "src", "main", "java"), gen_dir]:
        for root, dirs, files in os.walk(search_dir):
            for f in files:
                if f.endswith(".java"):
                    sources.append(os.path.abspath(os.path.join(root, f)))
    arg_file = os.path.join(BUILD_DIR, "java_sources.txt")
    with open(arg_file, "w", encoding="utf-8") as f:
        for s in sources:
            f.write('"' + s.replace('\\', '/') + '"\n')
    javac_cmd = [
        tools["javac"], "-encoding", "UTF-8", "-J-Dfile.encoding=UTF-8",
        "-source", "1.8", "-target", "1.8",
        "-d", obj_dir,
        "-cp", android_jar,
        "@" + arg_file
    ]
    subprocess.check_call(javac_cmd)
    print(f"[OK] Compiled Java classes into {obj_dir}")

    # Phase 04: D8 Dexing
    print("\n>>> [4/8] Converting Bytecode to classes.dex (D8)...")
    dex_dir = os.path.join(BUILD_DIR, "dex")
    r8_jar = os.path.join(TOOLS_DIR, "r8.jar")
    classes = []
    for root, dirs, files in os.walk(obj_dir):
        for f in files:
            if f.endswith(".class"):
                classes.append(os.path.abspath(os.path.join(root, f)))
    class_list = os.path.join(BUILD_DIR, "class_files.txt")
    with open(class_list, "w", encoding="utf-8") as f:
        for c in classes:
            f.write(c.replace('\\', '/') + '\n')
    d8_cmd = [
        tools["java"], "-cp", r8_jar, "com.android.tools.r8.D8",
        "--output", dex_dir,
        "--lib", android_jar,
        "--min-api", "24",
        "@" + class_list
    ]
    subprocess.check_call(d8_cmd)
    classes_dex = os.path.join(dex_dir, "classes.dex")
    print(f"[OK] Produced classes.dex ({os.path.getsize(classes_dex):,} bytes)")

    # Phase 05: Stage Assets
    print(f"\n>>> [5/8] Staging Runtime & Web Assets (no_bypass={no_bypass})...")
    stage_flags = ["--no-bypass"] if no_bypass else ["--region-bypass"]
    staging_dir = os.path.join(BUILD_DIR, "staging")
    subprocess.check_call([sys.executable, os.path.join(MODULES_DIR, "builder", "05_stage_assets.py"), staging_dir] + stage_flags)

    # Phase 06: Package Unaligned APK
    print("\n>>> [6/8] Packaging Unaligned APK (aapt + assets injection)...")
    unaligned_apk = os.path.join(BUILD_DIR, "unaligned.apk")
    pkg_cmd = [
        tools["aapt"], "package", "-f",
        "-M", target_manifest,
        "-S", build_res,
        "-S", res_dir,
        "--auto-add-overlay",
        "-I", android_jar,
        "-F", unaligned_apk
    ]
    subprocess.check_call(pkg_cmd)
    stage_assets = os.path.join(staging_dir, "assets")
    with zipfile.ZipFile(unaligned_apk, "a", compression=zipfile.ZIP_DEFLATED) as z:
        z.write(classes_dex, "classes.dex")
        if os.path.isdir(stage_assets):
            staging_parent = os.path.dirname(stage_assets)
            for root, dirs, files in os.walk(stage_assets):
                for f in files:
                    full = os.path.join(root, f)
                    rel = os.path.relpath(full, staging_parent)
                    comp = zipfile.ZIP_STORED if f.endswith(('.gz', '.tgz', '.zip', '.png', '.jpg')) else zipfile.ZIP_DEFLATED
                    z.write(full, rel, compress_type=comp)
    print(f"[OK] Packaged unaligned.apk ({os.path.getsize(unaligned_apk):,} bytes)")

    # Phase 07: ZipAlign
    print("\n>>> [7/8] ZipAligning APK...")
    aligned_apk = os.path.join(BUILD_DIR, "aligned.apk")
    subprocess.check_call([sys.executable, os.path.join(MODULES_DIR, "builder", "align.py"), unaligned_apk, aligned_apk, "4"])
    print(f"[OK] Aligned APK ({os.path.getsize(aligned_apk):,} bytes)")

    # Phase 08: Sign and Verify APK
    print("\n>>> [8/8] Signing and Verifying APK (apksigner)...")
    keystore = os.path.join(TOOLS_DIR, "debug.keystore")
    is_windows_bat = tools["apksigner"].endswith(".bat")
    sign_cmd = [
        tools["apksigner"], "sign",
        "--ks", keystore,
        "--ks-key-alias", "androiddebugkey",
        "--ks-pass", "pass:android",
        "--key-pass", "pass:android",
        "--out", out_apk,
        aligned_apk
    ]
    subprocess.check_call(sign_cmd, shell=is_windows_bat)
    print(f"[OK] Signed APK created: {out_apk} ({os.path.getsize(out_apk):,} bytes)")

    verify_cmd = [tools["apksigner"], "verify", "--verbose", out_apk]
    subprocess.check_call(verify_cmd, shell=is_windows_bat)
    print(f"[OK] Verified APK: {out_apk} is valid and ready for installation!")
    return out_apk


def compute_checksums(files=None):
    sums_file = os.path.join(DIST_DIR, "SHA256SUMS.txt")
    target_files = []
    if files:
        for f in files:
            if f and f not in target_files:
                target_files.append(f)
    for fname in ["antigravity.apk", "antigravity-region-bypass.apk", "antigravity.ipa"]:
        p = os.path.join(DIST_DIR, fname)
        if os.path.isfile(p) and p not in target_files:
            target_files.append(p)

    lines = []
    for path in sorted(target_files, key=lambda p: os.path.basename(p)):
        if os.path.isfile(path):
            hasher = hashlib.sha256()
            with open(path, "rb") as f:
                while chunk := f.read(65536):
                    hasher.update(chunk)
            lines.append(f"{hasher.hexdigest()}  {os.path.basename(path)}")
    with open(sums_file, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")
    print(f"\n[OK] Generated cryptographic checksums -> {sums_file}:")
    for l in lines:
        print(f"  {l}")
    return sums_file


def main():
    args = sys.argv[1:]

    # Dedicated iOS build mode (does not require Android SDK)
    if "--ios" in args or "--ipa" in args:
        ipa = build_ipa.build_ipa()
        compute_checksums([ipa])
        print("\n" + "=" * 60)
        print("  IOS & IPADOS PACKAGE (.IPA) SUCCESSFULLY BUILT!")
        print("=" * 60 + "\n")
        return

    tools = ensure_tools()
    print(f"Build tools detected:")
    for k, v in tools.items():
        print(f"  {k:10} -> {v}")

    if "--all" in args:
        apk1 = build_edition(tools, no_bypass=True)
        apk2 = build_edition(tools, no_bypass=False)
        ipa = build_ipa.build_ipa()
        compute_checksums([apk1, apk2, ipa])
    elif "--region-bypass" in args or "--bypass" in args:
        apk = build_edition(tools, no_bypass=False)
        compute_checksums([apk])
    else:
        apk = build_edition(tools, no_bypass=True)
        compute_checksums([apk])

    print("\n" + "=" * 60)
    print("  ALL REQUESTED PACKAGES SUCCESSFULLY BUILT AND VERIFIED!")
    print("=" * 60 + "\n")


if __name__ == "__main__":
    main()
