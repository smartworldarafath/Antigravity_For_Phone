# Antigravity for Android v1.0.0

## Release Packages Specification

| Package | Application ID | Target Port | Description |
| :--- | :--- | :--- | :--- |
| **`antigravity.apk`** | `com.agy` | 45157 | Standard production release with native bionic engine and official Google authentication flows. |
| **`antigravity-region-bypass.apk`** | `com.agy` | 45157 | Region bypass release with account eligibility check bypass (enables authentication from restricted locations). |
| **`SHA256SUMS.txt`** | — | — | Cryptographic SHA-256 checksums for binary package verification. |

---

## What's New in v1.0.0

### 1. High Refresh Rate Optimization (120Hz & 144Hz)
* **Dynamic Display Mode Negotiation:** Added `DisplayRefreshRateHelper` which queries `Display.getSupportedModes()` and matches resolution to negotiate the maximum available display refresh rate (120Hz, 144Hz, 165Hz) on Android 6.0+ (API 23+).
* **Adaptive Frame Rate Range:** On Android 11+ (API 30+), dynamically configures `preferredMaxDisplayRefreshRate` to 120Hz/144Hz while setting `preferredMinDisplayRefreshRate` to 60.0Hz. This unlocks locked 60fps+ fluidity during motion while allowing LTPO variable refresh rate displays to scale down power consumption during static viewing.
* **Surface Frame Rate Granting:** High frame rate compatibility (`setFrameRate(144f, 0)`) granted to WebView host containers.

### 2. Butter-Smooth 60fps+ Transitions & Extra Micro-Interactions
* **Spring-Damped Physics Interpolation:** Upgraded all transition easing tokens to modern spring curves (`cubic-bezier(0.16, 1, 0.3, 1)`).
* **Spring Button Micro-Interactions:** Added instant spring-press active state response (`button:active { transform: scale(0.972); }`) across all clickable elements and action icons.
* **GPU Hardware Compositing:** Enforced `transform: translateZ(0)`, `-webkit-overflow-scrolling: touch`, `scroll-behavior: smooth`, and `backface-visibility: hidden` across main layouts and chat scroll containers.
* **Layout Containment & Content Visibility:** Applied `contain: layout style` and `content-visibility: auto` to prevent off-screen layout thrashing and render lag.
* **Slick Splash Screen Exit Animation:** Enhanced splash screen exit dissolve with subtle scaling (`scale(1.025f)`) and decelerated fading for a seamless transition into the workspace.

### 3. Thermal Management & Battery Efficiency
* **Event-Driven Runtime Watchdogs:** Completely eliminated continuous 1000ms CPU polling in `MainActivity`. Server state transitions are now immediately pushed via `CoreRuntimeState.StateListener`, with polling backed off to 10s low-power watchdog intervals (over 90% reduction in idle CPU wakeups).
* **Smart WakeLock Lifecycle:** Updated `WakeLockHolder` with automatic safety timeouts (3 minutes max during startup) and automatic release once the core runtime is fully ready. Prevents device CPU lockup, phone overheating, and standby battery drain.
* **WebView Lifecycle Power Savings:** Thoroughly halts JavaScript timers (`pauseTimers()`) and Web rendering threads when the application is backgrounded or screen turned off.

### 4. Cross-Platform Standalone Build Pipeline
* Added `build.py` providing a clean, single-command cross-platform build orchestrator that compiles, dexes, stages assets, zipaligns, signs, and verifies APKs directly on Windows, Linux, and macOS without requiring Gradle.

### 5. Backend & App Version Alignment
* Version bumped to `v1.0.0` (versionCode 100, versionName 1.0.0).
* All native capabilities—built-in web terminal & PTY shell, Termux package manager, Shizuku ADB bridge, and background micro-daemon—remain 100% verified and operational.
