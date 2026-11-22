# Antigravity for Phone v1.0.0

## Release Packages Specification

| Package | Application ID | Platform | Target Port / Schema | Description |
| :--- | :--- | :--- | :--- | :--- |
| **`antigravity.apk`** | `com.agy` | Android (ARM64) | 45157 | Standard production release with native bionic engine and official Google authentication flows. |
| **`antigravity-region-bypass.apk`** | `com.agy` | Android (ARM64) | 45157 | Region bypass release with account eligibility check bypass (enables authentication from restricted locations). |
| **`antigravity.ipa`** | `com.agy.antigravity` | iOS & iPadOS (ARM64) | antigravity://app/ | Native iOS and iPadOS application package for iPhone and iPad with ProMotion 120Hz and multitasking support. |
| **`SHA256SUMS.txt`** | — | All | — | Cryptographic SHA-256 checksums for binary package verification. |

---

## What's New in v1.0.0

### 1. iOS and iPadOS Native Edition
* **Universal Device Compatibility:** Full native support for all modern iPhones and iPads running iOS / iPadOS 14.0 through iOS / iPadOS 18+.
* **iPad Multitasking:** Built-in support for iPad Stage Manager, Split View, and Slide Over, enabling side-by-side terminal and code editor multitasking.
* **Apple ProMotion (120Hz):** Integrated `CADisableMinimumFrameDurationOnPhone` and `CAFrameRateRange(min: 60, max: 120, preferred: 120)` dynamic display link pacing for iPhone Pro and iPad Pro models.
* **Native Security-Scoped Document Picker:** Seamless workspace import and export via Apple Files app, iCloud Drive, and local device storage.
* **Thermal and Battery Guard:** Native `ProcessInfo.thermalStateDidChangeNotification` and Low Power Mode observers that dynamically throttle frame pacing and suspend background WebKit timers to protect device battery and thermals.
* **Multiple Installation Methods:** Fully compatible with AltStore, SideStore, TrollStore, Scarlet, Sideloadly, and Xcode developer signing.

### 2. High Refresh Rate Optimization (120Hz & 144Hz)
* **Dynamic Display Mode Negotiation:** Added `DisplayRefreshRateHelper` which queries `Display.getSupportedModes()` and matches resolution to negotiate the maximum available display refresh rate (120Hz, 144Hz, 165Hz) on Android 6.0+ (API 23+).
* **Adaptive Frame Rate Range:** On Android 11+ (API 30+), dynamically configures `preferredMaxDisplayRefreshRate` to 120Hz/144Hz while setting `preferredMinDisplayRefreshRate` to 60.0Hz. This unlocks locked 60fps+ fluidity during motion while allowing LTPO variable refresh rate displays to scale down power consumption during static viewing.
* **Surface Frame Rate Granting:** High frame rate compatibility (`setFrameRate(144f, 0)`) granted to WebView host containers.

### 3. Butter-Smooth 60fps+ Transitions & Extra Micro-Interactions
* **Spring-Damped Physics Interpolation:** Upgraded all transition easing tokens to modern spring curves (`cubic-bezier(0.16, 1, 0.3, 1)`).
* **Spring Button Micro-Interactions:** Added instant spring-press active state response (`button:active { transform: scale(0.972); }`) across all clickable elements and action icons.
* **GPU Hardware Compositing:** Enforced `transform: translateZ(0)`, `-webkit-overflow-scrolling: touch`, `scroll-behavior: smooth`, and `backface-visibility: hidden` across main layouts and chat scroll containers.
* **Layout Containment & Content Visibility:** Applied `contain: layout style` and `content-visibility: auto` to prevent off-screen layout thrashing and render lag.
* **Slick Splash Screen Exit Animation:** Enhanced splash screen exit dissolve with subtle scaling (`scale(1.025f)`) and decelerated fading for a seamless transition into the workspace.

### 4. Thermal Management & Battery Efficiency
* **Event-Driven Runtime Watchdogs:** Completely eliminated continuous 1000ms CPU polling in `MainActivity`. Server state transitions are now immediately pushed via `CoreRuntimeState.StateListener`, with polling backed off to 10s low-power watchdog intervals (over 90% reduction in idle CPU wakeups).
* **Smart WakeLock Lifecycle:** Updated `WakeLockHolder` with automatic safety timeouts (3 minutes max during startup) and automatic release once the core runtime is fully ready. Prevents device CPU lockup, phone overheating, and standby battery drain.
* **WebView Lifecycle Power Savings:** Halts JavaScript timers (`pauseTimers()`) and Web rendering threads when the application is backgrounded or screen turned off.

### 5. Unified Cross-Platform Build Pipeline
* Added `build.py` providing a clean, single-command cross-platform build orchestrator that compiles, dexes, stages assets, zipaligns, signs, and verifies APKs, as well as packaging iOS IPAs directly on Windows, Linux, and macOS without external heavy IDE bloat.

### 6. Backend & App Version Alignment
* Version bumped to `v1.0.0` across Android, iOS, and runtime configurations.
* All native capabilities—built-in web terminal & PTY shell, Termux package manager, Shizuku ADB bridge, and background micro-daemon—remain 100% verified and operational.
