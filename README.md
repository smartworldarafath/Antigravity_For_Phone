<div align="center">

  <p>
    <b>English</b> &nbsp;&bull;&nbsp; <a href="README.ru.md">Русский</a>
  </p>

  <br/>

  <img src="docs/assets/logo.png" alt="Antigravity" width="88" height="88" style="border-radius: 20px;" />

  # Antigravity for Android

**Autonomous AI development environment running natively on Android & ARM64.**

  [![Android](https://img.shields.io/badge/Android-7.0%2B-3DDC84?style=flat-square&logo=android&logoColor=white)](https://android.com)
  [![Arch](https://img.shields.io/badge/ARM64-v8.0--A%2B-blue?style=flat-square)](https://arm.com)
  [![Release](https://img.shields.io/badge/Version-1.0.0-blueviolet?style=flat-square)](https://github.com/smartworldarafath/Antigravity_For_Android/releases)
  [![License](https://img.shields.io/badge/License-Apache_2.0-orange?style=flat-square)](LICENSE)

  <br/>

  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/assets/hero_dark.png">
    <source media="(prefers-color-scheme: light)" srcset="docs/assets/hero_light.png">
    <img alt="Antigravity Interface" src="docs/assets/hero_dark.png" width="100%" style="border-radius: 12px; border: 1px solid rgba(128,128,128,0.2);" />
  </picture>

</div>

---

### Overview

**Antigravity for Android** brings autonomous agentic coding directly to mobile hardware.

No PRoot, chroot, or virtualization overhead. Antigravity runs **bare-metal inside native Android userspace (Bionic)**, unleashing the full read/write speed of UFS storage and physical CPU cores. Driven by Gemini models, the agent inspects repositories, authors code across multiple files, compiles binaries, and runs tests completely on-device.

---

### Highlights in v1.0.0

* **120Hz & 144Hz High Refresh Rate Support:** Seamless dynamic refresh rate switching with resolution-matched mode selection and adaptive frame rate bounds (60Hz–144Hz) for LTPO/VRR displays.
* **Butter Smooth 60fps+ Transitions:** Modern spring-damped micro-interactions (`cubic-bezier(0.16, 1, 0.3, 1)`), smooth popup scaling, hardware-accelerated compositing (`transform: translateZ(0)`), and seamless splash screen dissolve.
* **Thermal Management & Battery Efficiency:** Event-driven architecture completely replaces continuous 1-second CPU polling loops with low-power watchdogs. Smart wakelock management ensures zero idle drain and prevents phone heating.
* **Cross-Platform APK Builder (`build.py`):** Unified Python builder compiling Java, dexing via D8, staging assets, zipaligning, and signing directly on Windows, Linux, and macOS without Gradle.
* **All Native Core Features Intact:** Built-in web terminal & PTY shell, Shizuku ADB bridge, Termux package manager, OAuth authentication flows, and background micro-daemon remain 100% functional.

---

### Key Features

* **Autonomous Agent:** Plans tasks, edits code across project trees, executes shell tools, and fixes build errors.
* **Elevated Control (Shizuku):** Direct ADB-level operations (`uid=2000`) without root for package installs and system diagnostics.
* **Built-in `pkg` Manager:** Fast package manager installing development runtimes (`git`, `python`, `node`, `clang`) from Termux repos.
* **Adaptive Viewports:** Seamless touch-first mobile UI with optional desktop layout.
* **In-Place Upgrades:** Consistent keystore guarantees updating APKs without losing sessions or workspace data.

---

### Quick Start

1. **Download APK** from [Releases](https://github.com/smartworldarafath/Antigravity_For_Android/releases):
   * `antigravity.apk` — standard release (original Google account checks).
   * `antigravity-region-bypass.apk` — release with account eligibility check bypass.
2. **Grant Storage Permission** (`All Files Access`). *(Optional: enable Shizuku for ADB access)*.
3. **Install Runtimes** via terminal or agent:
   ```bash
   pkg update && pkg install git python nodejs
   ```

---

### Building & Testing

```bash
# Build standard release APK (dist/antigravity.apk):
python build.py

# Build release APK with region bypass (dist/antigravity-region-bypass.apk):
python build.py --region-bypass

# Build both editions & SHA256SUMS.txt:
python build.py --all
```

---

### Repository Structure

```text
antigravity/
├── config/             # App constants, environment paths, and AI rules
├── modules/            # Decoupled core modules
│   ├── core/           # Binary unpacking, glibc loader, shims, SHA-256 manifest
│   ├── patches/        # Binary patch engine (syscall emulation, resolv, SIGILL)
│   ├── io/             # High-performance I/O Bus: event broker, FIFO pipes, sockets
│   ├── env/            # Path resolver, diagnostics, Flight Recorder logs, CLI
│   ├── builder/        # Gradle-free APK builder (javac, D8, aapt, zipalign, apksigner)
│   └── runner/         # Standalone runtime preparation, port probe, E2E tests
├── app/                # Android host app (native splash, WebView, system bridges, 120Hz/144Hz)
├── web/                # Local web frontend, desktop mode toggle, butter-smooth transitions
├── env/                # Bionic userspace, Termux overlay, pkg manager, liblse_compat
├── docs/assets/        # Screenshots, banners, and diagrams
├── build.py            # Cross-platform root APK builder
├── build.sh            # Root APK build script
└── test_all_modules.sh # Test suite for all 6 modules
```

---

<div align="center">
  <sub>Licensed under the <a href="LICENSE">Apache 2.0 License</a></sub>
</div>
