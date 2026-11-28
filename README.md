<div align="center">

  <p>
    <b>English</b> &nbsp;&bull;&nbsp; <a href="README.ru.md">Русский</a>
  </p>

  <br/>

  <img src="docs/assets/logo.png" alt="Antigravity" width="88" height="88" style="border-radius: 20px;" />

  # Antigravity for Phone

  <b>Universal Autonomous AI Development Environment for iPhone, iPad, and Android</b>

  <br/>

  <p>
    <a href="https://github.com/smartworldarafath/Antigravity_For_Phone/releases"><img src="https://img.shields.io/badge/Release-v1.0.0-blueviolet?style=flat-square" alt="Version 1.0.0" /></a>
    <a href="https://www.apple.com/ios/"><img src="https://img.shields.io/badge/iOS%20%2F%20iPadOS-14.0%2B-black?style=flat-square&logo=apple&logoColor=white" alt="iOS and iPadOS" /></a>
    <a href="https://www.android.com"><img src="https://img.shields.io/badge/Android-7.0%2B-3DDC84?style=flat-square&logo=android&logoColor=white" alt="Android" /></a>
    <a href="https://www.arm.com"><img src="https://img.shields.io/badge/Architecture-ARM64-blue?style=flat-square" alt="ARM64" /></a>
    <a href="LICENSE"><img src="https://img.shields.io/badge/License-Apache_2.0-orange?style=flat-square" alt="Apache 2.0" /></a>
  </p>

  <br/>

  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="docs/assets/hero_dark.png">
    <source media="(prefers-color-scheme: light)" srcset="docs/assets/hero_light.png">
    <img alt="Antigravity Interface" src="docs/assets/hero_dark.png" width="100%" style="border-radius: 12px; border: 1px solid rgba(128,128,128,0.2);" />
  </picture>

</div>

---


<div align="center">

### 🛠️ Languages & Tech Stack

<p>
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/smartworldarafath/smartworldarafath/main/assets/readme/dark/pill-js.svg" />
    <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/smartworldarafath/smartworldarafath/main/assets/readme/light/pill-js.svg" />
    <img src="https://raw.githubusercontent.com/smartworldarafath/smartworldarafath/main/assets/readme/dark/pill-js.svg" alt="JavaScript" />
  </picture>
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/smartworldarafath/smartworldarafath/main/assets/readme/dark/pill-java.svg" />
    <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/smartworldarafath/smartworldarafath/main/assets/readme/light/pill-java.svg" />
    <img src="https://raw.githubusercontent.com/smartworldarafath/smartworldarafath/main/assets/readme/dark/pill-java.svg" alt="Java" />
  </picture>
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/smartworldarafath/smartworldarafath/main/assets/readme/dark/pill-css.svg" />
    <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/smartworldarafath/smartworldarafath/main/assets/readme/light/pill-css.svg" />
    <img src="https://raw.githubusercontent.com/smartworldarafath/smartworldarafath/main/assets/readme/dark/pill-css.svg" alt="CSS3" />
  </picture>
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/smartworldarafath/smartworldarafath/main/assets/readme/dark/pill-python.svg" />
    <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/smartworldarafath/smartworldarafath/main/assets/readme/light/pill-python.svg" />
    <img src="https://raw.githubusercontent.com/smartworldarafath/smartworldarafath/main/assets/readme/dark/pill-python.svg" alt="Python" />
  </picture>
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/smartworldarafath/smartworldarafath/main/assets/readme/dark/pill-shell.svg" />
    <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/smartworldarafath/smartworldarafath/main/assets/readme/light/pill-shell.svg" />
    <img src="https://raw.githubusercontent.com/smartworldarafath/smartworldarafath/main/assets/readme/dark/pill-shell.svg" alt="Shell" />
  </picture>
</p>

</div>

## Overview

Antigravity for Phone brings complete, autonomous AI coding workflows straight into your pocket. Built from the ground up for modern smartphones and tablets, Antigravity empowers developers to run agentic coding workflows locally on Android devices, iPhones, and iPads without clunky desktop tethering or cloud server dependencies.

On Android, Antigravity runs bare-metal inside native userspace (Bionic) without PRoot, chroot, or emulation overhead, tapping into the full multi-core performance of your SoC and the high read/write speeds of UFS storage. 

On iOS and iPadOS, Antigravity runs as a native application optimized for Apple ProMotion displays, iPad Stage Manager, Split View, and Slide Over, with seamless workspace file management via Apple Files and iCloud Drive.

Powered by advanced Gemini models, the embedded agent investigates project trees, writes and refactors code across complex repositories, handles build pipelines, executes commands, and fixes syntax and runtime defects on the fly.

---

## Release Packages (v1.0.0)

Every binary package is compiled, signed, and published under [GitHub Releases](https://github.com/smartworldarafath/Antigravity_For_Phone/releases/tag/v1.0.0).

| Binary Artifact | Platform | Architecture | Description |
| :--- | :--- | :--- | :--- |
| **`antigravity.ipa`** | iOS & iPadOS (14.0 - 18+) | ARM64 | Universal native iOS application package for all iPhones and iPads. Fully compatible with AltStore, SideStore, TrollStore, Scarlet, Sideloadly, and Xcode. |
| **`antigravity.apk`** | Android (7.0 - 15+) | ARM64 | Standard production Android release with native bionic runtime, PTY terminal, and official Google authentication. |
| **`antigravity-region-bypass.apk`** | Android (7.0 - 15+) | ARM64 | Android edition with account location eligibility check bypass, allowing sign-in from any geographic location. |
| **`SHA256SUMS.txt`** | All Platforms | — | Official SHA-256 cryptographic hashes for verifying package integrity. |

---

## Core Engineering Highlights

### 1. High Refresh Rate Display Pipeline (120Hz & 144Hz)
* **Android:** Dynamic display mode negotiation via `DisplayRefreshRateHelper`. Scans `Display.getSupportedModes()`, matches display resolution, and sets the window to 120Hz, 144Hz, or 165Hz with API 31 `setFrameRate` synchronization.
* **Apple ProMotion (iOS & iPadOS):** Unlocks 120Hz dynamic refresh rates on iPhone Pro (13 Pro through 16 Pro Max) and iPad Pro models using `CADisableMinimumFrameDurationOnPhone` and `CAFrameRateRange(min: 60, max: 120, preferred: 120)`.
* **Adaptive Frame Pacing:** Motion operates at a rock-solid 60fps to 120fps/144fps, while static views drop frequency on LTPO variable refresh rate screens to preserve power.

### 2. Butter-Smooth 60fps+ Transitions and Micro-Interactions
* **Spring-Damped Physics Interpolation:** Every dialog, drawer, menu, and modal uses modern spring-eased curves (`cubic-bezier(0.16, 1, 0.3, 1)`).
* **Tactile Spring Active States:** Buttons and icons deliver instantaneous haptic visual feedback on press (`button:active { transform: scale(0.972); }`).
* **GPU Hardware Compositing:** CSS layers utilize `transform: translateZ(0)` and `backface-visibility: hidden` to eliminate layout re-flows and dropped frames.
* **Content Visibility & Containment:** Applied `contain: layout style` and `content-visibility: auto` across chat and editor viewports to maintain smooth scrolling on large repositories.
* **Seamless Splash Dissolve:** Splash screens fade out with decelerated scale interpolation (`scale(1.025f)`), eliminating white flashes and abrupt cuts.

### 3. Thermal Management and Zero Idle Battery Drain
* **Event-Driven Runtime Watchdogs:** Replaced continuous 1000ms CPU polling loops with an event-driven `StateListener` architecture. Watchdogs back off to 10-second intervals during idle states, cutting standby CPU wakeups by more than 90%.
* **Smart WakeLock Lifecycle (Android):** Replaces permanent CPU wakelocks with a 3-minute bootstrap guard that automatically releases as soon as the core server reaches ready state. Eliminates phone overheating in your pocket.
* **Native Thermal State Guards (iOS):** Subscribes to `ProcessInfo.thermalStateDidChangeNotification` and Low Power Mode notifications, intelligently adjusting frame rates and pausing background WebKit timers when the device is warm or running low on battery.

### 4. iPad Multitasking & Desktop Ergonomics
* Full support for iPad Stage Manager, Split View, and Slide Over. Run Antigravity side-by-side with Safari, Notes, or your favorite git client.
* Full external hardware keyboard and trackpad support with native modifier keys.
* Adaptive interface switching between touch-optimized phone layout and tablet desktop workspace.

---

## iPhone and iPad Installation Guide

Antigravity for iOS is distributed as an unsigned IPA package (`antigravity.ipa`). Because iOS requires applications to be signed with an Apple ID or developer certificate, you can install Antigravity on any iPhone or iPad using any of the following reliable sideloading methods.

### Device Compatibility
* **Supported Devices:** All iPhones and iPads with 64-bit processors (iPhone 6s through iPhone 16 Pro Max; iPad Air 2 through iPad Pro M4; iPad mini 4 through iPad mini 7; iPad 5th gen through 10th gen).
* **Supported Operating Systems:** iOS 14.0, 15.x, 16.x, 17.x, and 18+.

---

### Method 1: Sideloading via AltStore (Windows PC or Mac)

AltStore is one of the most widely used and stable methods to install IPAs using your personal Apple ID.

#### Prerequisites
* A computer running Windows 10/11 or macOS 10.14.4+.
* On Windows: Install iTunes (Win32, non-Microsoft Store version) and iCloud (non-Microsoft Store version) from Apple's website.
* A standard Lightning or USB-C cable to connect your iPhone or iPad.

#### Step-by-Step Instructions
1. Download and install **AltServer** on your computer from [altstore.io](https://altstore.io).
2. Connect your iPhone or iPad to your computer via USB. Unlock the device and tap **Trust This Computer** if prompted.
3. Launch AltServer:
   * **On macOS:** Click the AltServer icon in the menu bar, select **Install Mail Plug-in**, restart the Mail app, and enable the plug-in under Mail > Settings > General > Manage Plug-ins.
   * **On Windows:** Click the AltServer icon in the system tray.
4. In AltServer, select **Install AltStore**, choose your connected iPhone or iPad, and enter your Apple ID and password (credentials are sent directly to Apple to generate a free 7-day development certificate).
5. Once AltStore appears on your iPhone/iPad home screen:
   * Go to **Settings > General > VPN & Device Management**.
   * Under Developer App, tap your Apple ID and select **Trust**.
   * On iOS 16, 17, and 18: Go to **Settings > Privacy & Security > Developer Mode**, turn it ON, and restart your device when prompted.
6. Open Safari on your iPhone or iPad, navigate to [Releases](https://github.com/smartworldarafath/Antigravity_For_Phone/releases/tag/v1.0.0), and download **`antigravity.ipa`**.
7. Open the **AltStore** app on your device, navigate to the **My Apps** tab, tap the **+** (plus) icon in the top-left corner, and select the downloaded `antigravity.ipa`.
8. AltStore will sign and install Antigravity. Once complete, launch Antigravity from your home screen.

---

### Method 2: Sideloading via SideStore (PC-Free after initial setup)

SideStore allows you to sign and refresh apps directly on your iPhone or iPad using a local WireGuard loopback VPN, meaning you never need a computer after initial installation.

#### Step-by-Step Instructions
1. Follow the initial SideStore setup guide at [sidestore.io](https://sidestore.io) to install SideStore onto your device via your computer.
2. Ensure the **SideStore WireGuard VPN** profile is active on your device.
3. Download **`antigravity.ipa`** from [Releases](https://github.com/smartworldarafath/Antigravity_For_Phone/releases/tag/v1.0.0) in Safari.
4. Open the **SideStore** app, go to the **My Apps** tab, and tap the **+** button.
5. Select `antigravity.ipa`. SideStore will sign the package locally on your device and install it.
6. Antigravity is now ready to launch.

---

### Method 3: TrollStore (Permanent Install, No Revokes, iOS 14.0 - 17.0)

If your device runs a firmware version compatible with TrollStore (iOS 14.0 through 16.6.1, and certain 17.0 builds), TrollStore provides permanent installation with full entitlement support and zero 7-day certificate expiration.

#### Step-by-Step Instructions
1. Open the **TrollStore** app on your iPhone or iPad.
2. Download **`antigravity.ipa`** from [Releases](https://github.com/smartworldarafath/Antigravity_For_Phone/releases/tag/v1.0.0) in Safari.
3. In Safari Downloads, tap on `antigravity.ipa`, tap the **Share** button, and choose **TrollStore**.
   * Alternatively: In TrollStore, tap the **+** icon in the top right, select **Install IPA File**, and browse to `antigravity.ipa`.
4. Tap **Install**. TrollStore installs Antigravity instantly with elevated privileges and permanent signature.
5. Launch Antigravity directly from your home screen or TrollStore app list.

---

### Method 4: Sideloadly (Windows & macOS Drag-and-Drop)

Sideloadly is a fast desktop tool that injects IPAs over USB or Wi-Fi.

#### Step-by-Step Instructions
1. Download and install **Sideloadly** from [sideloadly.io](https://sideloadly.io).
2. Connect your iPhone or iPad to your computer via USB.
3. Download **`antigravity.ipa`** to your computer from [Releases](https://github.com/smartworldarafath/Antigravity_For_Phone/releases/tag/v1.0.0).
4. Drag and drop `antigravity.ipa` into the large IPA icon box inside Sideloadly.
5. Enter your Apple ID in the Apple account field.
6. Click **Start**. Sideloadly signs and pushes the app directly to your device.
7. On your iPhone/iPad, go to **Settings > General > VPN & Device Management**, trust your developer certificate, and open Antigravity.

---

### Method 5: Scarlet (Direct OTA / Device Sideloading)

Scarlet provides direct on-device IPA installation through enterprise certificates or computer-linked signing.

#### Step-by-Step Instructions
1. Open the **Scarlet** app on your iPhone or iPad.
2. Download **`antigravity.ipa`** from [Releases](https://github.com/smartworldarafath/Antigravity_For_Phone/releases/tag/v1.0.0).
3. In Scarlet, tap the **Install / Sideload** icon in the navigation bar.
4. Select `antigravity.ipa` from your device storage.
5. Confirm installation. The app will appear on your home screen ready for use.

---

### Method 6: Xcode and iOS App Signer (macOS Developers)

For macOS users with an active Apple Developer account or free developer profile:

#### Step-by-Step Instructions
1. Clone this repository to your Mac:
   ```bash
   git clone https://github.com/smartworldarafath/Antigravity_For_Phone.git
   ```
2. Open the `ios/` folder or generate the Xcode project using Swift Package Manager:
   ```bash
   cd Antigravity_For_Phone/ios
   swift package generate-xcodeproj
   ```
3. Open `Antigravity.xcodeproj` in Xcode.
4. Select your connected iPhone or iPad as the build destination.
5. Under **Signing & Capabilities**, select your personal or organization Development Team.
6. Click **Run** (Command + R) to build, sign, and install Antigravity directly onto your hardware.

---

## Android Installation Guide

### Device Requirements
* **Architecture:** ARM64 (aarch64) SoC.
* **Operating System:** Android 7.0 (API 24) or higher (fully verified on Android 12, 13, 14, and 15).
* **Storage:** At least 500 MB free internal storage.

---

### Step-by-Step Instructions

#### Step 1: Choose Your Package
Download your preferred edition from [Releases](https://github.com/smartworldarafath/Antigravity_For_Phone/releases/tag/v1.0.0):
* **`antigravity.apk`**: Standard release. Recommended for users in supported regions with standard Google authentication.
* **`antigravity-region-bypass.apk`**: Region bypass edition. Recommended if you reside in a region where Google AI features are geographically restricted; bypasses account eligibility checks.

#### Step 2: Install the APK
1. Open the downloaded `.apk` file using your device's file manager or browser downloads.
2. When prompted by Android, allow **Install unknown apps** for your browser or file manager.
3. Tap **Install** and wait for the package installer to finish.

#### Step 3: Grant Required Permissions
1. Launch Antigravity from your app drawer.
2. On first launch, grant **All Files Access** (Storage permission). This is required so the agent can read and write code in project workspaces on your device storage.
3. If running on Android 13+, allow notification permissions so background agent tasks and build completions can alert you.

#### Step 4: Setup Command-Line Tools and Packages
Antigravity features a built-in terminal and package manager. To install your favorite compilers and developer tools:
```bash
pkg update
pkg install git python nodejs clang
```

#### Step 5 (Optional): Elevated Privileges via Shizuku
To unlock rootless ADB-level control (installing packages silently, advanced system inspection, elevated terminal operations):
1. Install and start [Shizuku](https://shizuku.rikka.app) on your device via Wireless Debugging.
2. Open Antigravity and allow the Shizuku permission prompt when requested.

---

## Workspace & File Management

### On iOS and iPadOS
* **Apple Files Integration:** Antigravity includes a native Document Picker. Tap the folder icon in the navigation bar to import project folders from iCloud Drive, Working Copy, GitHub repositories, or On My iPhone/iPad local directories.
* **Security-Scoped Bookmarks:** Selected project folders are granted persistent read-write access without re-prompting.

### On Android
* **Native Bionic Filesystem:** Direct access to `/sdcard/` and app-private storage (`/data/data/com.agy/files/`).
* **External Storage Workspaces:** Store your git repositories anywhere in internal storage or micro-SD cards.

---

## Building from Source

Antigravity features a unified, cross-platform build pipeline (`build.py`) that runs on Windows, Linux, and macOS without requiring Gradle.

### Prerequisites
* Python 3.8 or higher.
* For Android APK builds: Android SDK build-tools (`aapt`, `apksigner`, `zipalign`) and JDK 17+.
* For iOS IPA builds: Standard Python 3 (no macOS or Xcode required to generate the IPA archive).

### Build Commands

```bash
# Clone the repository
git clone https://github.com/smartworldarafath/Antigravity_For_Phone.git
cd Antigravity_For_Phone

# 1. Build standard Android release (dist/antigravity.apk)
python build.py

# 2. Build Android release with region bypass (dist/antigravity-region-bypass.apk)
python build.py --region-bypass

# 3. Build iOS and iPadOS package (dist/antigravity.ipa)
python build.py --ios

# 4. Build all editions simultaneously and compute SHA256SUMS.txt
python build.py --all
```

All built binaries and cryptographic hashes will be staged in the `dist/` directory.

---

## Project Structure

```text
Antigravity_For_Phone/
├── app/                        # Android host application
│   ├── src/main/java/com/agy/
│   │   ├── core/               # Runtime state, wake lock management, port probe
│   │   ├── ui/refresh/         # 120Hz & 144Hz DisplayRefreshRateHelper
│   │   ├── ui/splash/          # Native animated splash controller
│   │   └── web/                # High-performance WebView container & bridges
│   └── src/main/AndroidManifest.xml
├── ios/                        # iOS & iPadOS native application
│   ├── Antigravity/
│   │   ├── App/                # SwiftUI App lifecycle entry
│   │   ├── Bridge/             # WebScriptBridge and LocalSchemeHandler
│   │   ├── Controllers/        # MainViewController with WKWebView
│   │   ├── Core/               # ProMotion 120Hz & ThermalBatteryManager
│   │   ├── Resources/          # Info.plist, Entitlements, Assets.xcassets
│   │   └── Views/              # Native splash and UI views
│   ├── Package.swift           # Swift Package Manager definition
│   └── build_ipa.py            # Standalone IPA packaging script
├── modules/                    # Core decoupled subsystems
│   ├── builder/                # Gradle-free APK builder (aapt, javac, d8, apksigner)
│   ├── core/                   # Bionic loader, glibc shims, manifest validator
│   ├── env/                    # Environment resolver and flight recorder logs
│   ├── io/                     # Asynchronous I/O bus and FIFO pipe broker
│   ├── patches/                # Web runtime and binary patch engine
│   └── runner/                 # Runtime bootstrap and verification tests
├── web/                        # Web application frontend
│   ├── index.html              # Main workspace interface
│   ├── jetbox.css              # 60fps+ transitions, spring physics, layout containment
│   └── src/patches/            # GPU compositing and performance patches
├── config/                     # Application environment variables and AI directives
├── dist/                       # Output directory for compiled APKs and IPAs
├── build.py                    # Root cross-platform unified build script
├── RELEASE_NOTES.md            # Detailed release documentation
└── LICENSE                     # Apache 2.0 open-source license
```

---

## Security and Privacy

Antigravity operates with strict local-first privacy principles:
* No telemetry, trackers, or hidden analytics are embedded in the code.
* Credentials and API keys are stored strictly in local secure app storage.
* Network traffic is strictly confined to your chosen AI model provider and local server sockets.

---

## License

This project is licensed under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for complete terms and copyright notices.
