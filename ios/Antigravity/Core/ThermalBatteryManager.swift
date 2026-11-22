//
//  ThermalBatteryManager.swift
//  Antigravity for iOS / iPadOS
//

import UIKit
import WebKit

/// Monitors system thermal state, power state (Low Power Mode), and app lifecycle
/// to prevent device overheating and battery drain.
public final class ThermalBatteryManager {

    public static let shared = ThermalBatteryManager()

    private var currentThermalState: ProcessInfo.ThermalState = .nominal
    private var isLowPowerMode: Bool = false
    private weak var webView: WKWebView?

    private init() {
        setupObservers()
    }

    public func configure(with webView: WKWebView) {
        self.webView = webView
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleThermalChange),
            name: ProcessInfo.thermalStateDidChangeNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePowerModeChange),
            name: NSNotification.Name.NSProcessInfoPowerStateDidChange,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    @objc private func handleThermalChange() {
        currentThermalState = ProcessInfo.processInfo.thermalState
        HighRefreshRateManager.shared.updatePerformanceProfile(
            thermalState: currentThermalState,
            isLowPower: isLowPowerMode
        )

        // Inject thermal state into webview for CSS/JS throttle if needed
        let stateStr: String
        switch currentThermalState {
        case .nominal: stateStr = "nominal"
        case .fair: stateStr = "fair"
        case .serious: stateStr = "serious"
        case .critical: stateStr = "critical"
        @unknown default: stateStr = "unknown"
        }
        let js = "window.__agThermalState = '\(stateStr)';"
        webView?.evaluateJavaScript(js, completionHandler: nil)
    }

    @objc private func handlePowerModeChange() {
        isLowPowerMode = ProcessInfo.processInfo.isLowPowerModeEnabled
        HighRefreshRateManager.shared.updatePerformanceProfile(
            thermalState: currentThermalState,
            isLowPower: isLowPowerMode
        )
    }

    @objc private func handleEnterBackground() {
        HighRefreshRateManager.shared.pause()
        // Freeze JavaScript timers to stop background battery consumption
        webView?.evaluateJavaScript("(function(){ if (window.__agPauseBackground) window.__agPauseBackground(); })();", completionHandler: nil)
    }

    @objc private func handleEnterForeground() {
        HighRefreshRateManager.shared.resume()
        // Resume JavaScript timers
        webView?.evaluateJavaScript("(function(){ if (window.__agResumeForeground) window.__agResumeForeground(); })();", completionHandler: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
