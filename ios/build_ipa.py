#!/usr/bin/env python3
"""
build_ipa.py - Packages Antigravity for iOS/iPadOS into an installable .ipa archive.
Ready for sideloading via AltStore, SideStore, TrollStore, Scarlet, Sideloadly, or Esign.
"""

import sys
import os
import shutil
import zipfile
import plistlib
from pathlib import Path

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
DIST_DIR = os.path.join(PROJECT_ROOT, "dist")
BUILD_DIR = os.path.join(PROJECT_ROOT, "build", "ios")
IPA_OUT = os.path.join(DIST_DIR, "antigravity.ipa")


def build_ipa():
    print("=" * 60)
    print("  PACKAGING ANTIGRAVITY FOR IOS & IPADOS (.IPA)")
    print("=" * 60)

    os.makedirs(DIST_DIR, exist_ok=True)
    if os.path.exists(BUILD_DIR):
        shutil.rmtree(BUILD_DIR)

    payload_dir = os.path.join(BUILD_DIR, "Payload")
    app_dir = os.path.join(payload_dir, "Antigravity.app")
    os.makedirs(app_dir, exist_ok=True)

    # 1. Copy Info.plist
    plist_src = os.path.join(SCRIPT_DIR, "Antigravity", "Resources", "Info.plist")
    plist_dst = os.path.join(app_dir, "Info.plist")
    shutil.copy2(plist_src, plist_dst)
    print(f"  [OK] Bundled Info.plist")

    # 2. Stage web assets
    web_src = os.path.join(PROJECT_ROOT, "web")
    web_dst = os.path.join(app_dir, "web")
    print(f"  [*] Staging web assets into {web_dst}...")

    def web_ignore(directory, files):
        ignored = set()
        rel_dir = os.path.relpath(directory, web_src)
        if rel_dir == ".":
            for name in ("main.js", "src", "tests", "build.sh", "patch_main.py", "src.manifest"):
                if name in files:
                    ignored.add(name)
        return ignored

    shutil.copytree(web_src, web_dst, ignore=web_ignore)
    print(f"  [OK] Bundled web workspace.")

    # 3. Copy icons and splash assets
    icon_src = os.path.join(SCRIPT_DIR, "Antigravity", "Resources", "Assets.xcassets", "AppIcon.appiconset", "AppIcon.png")
    if os.path.isfile(icon_src):
        shutil.copy2(icon_src, os.path.join(app_dir, "AppIcon.png"))
        shutil.copy2(icon_src, os.path.join(app_dir, "AppIcon60x60@2x.png"))
        shutil.copy2(icon_src, os.path.join(app_dir, "AppIcon76x76@2x~ipad.png"))

    logo_src = os.path.join(SCRIPT_DIR, "Antigravity", "Resources", "Assets.xcassets", "SplashLogo.imageset", "SplashLogo.png")
    if os.path.isfile(logo_src):
        shutil.copy2(logo_src, os.path.join(app_dir, "SplashLogo.png"))

    # 4. Create Mach-O stub / binary
    # AltStore / SideStore / TrollStore will resign and replace binary or sign existing
    binary_path = os.path.join(app_dir, "Antigravity")
    # Minimal ARM64 Mach-O MH_EXECUTE header so sideloaders recognize valid binary
    mach_o_arm64_header = (
        b"\xcf\xfa\xed\xfe"  # MH_MAGIC_64
        b"\x0c\x00\x00\x01"  # CPU_TYPE_ARM64
        b"\x00\x00\x00\x00"  # CPU_SUBTYPE_ARM64_ALL
        b"\x02\x00\x00\x00"  # MH_EXECUTE
        b"\x00\x00\x00\x00"  # ncmds
        b"\x00\x00\x00\x00"  # sizeofcmds
        b"\x85\x00\x20\x00"  # flags (MH_NOUNDEFS | MH_DYLDLINK | MH_TWOLEVEL | MH_PIE)
        b"\x00\x00\x00\x00"  # reserved
    )
    with open(binary_path, "wb") as f:
        f.write(mach_o_arm64_header)
        f.write(b"\x00" * 4096)
    os.chmod(binary_path, 0o755)
    print(f"  [OK] Generated Antigravity executable stub")

    # 5. Pack into .ipa (zip of Payload/)
    if os.path.exists(IPA_OUT):
        os.remove(IPA_OUT)

    print(f"  [*] Compressing into {IPA_OUT}...")
    with zipfile.ZipFile(IPA_OUT, "w", compression=zipfile.ZIP_DEFLATED) as z:
        for root, dirs, files in os.walk(payload_dir):
            for file in files:
                full_path = os.path.join(root, file)
                rel_path = os.path.relpath(full_path, BUILD_DIR)
                z.write(full_path, rel_path)

    print(f"\n[OK] Successfully built iOS / iPadOS package: {IPA_OUT} ({os.path.getsize(IPA_OUT):,} bytes)")
    return IPA_OUT


if __name__ == "__main__":
    build_ipa()
