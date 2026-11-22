//
//  HighRefreshRateManager.swift
//  Antigravity for iOS / iPadOS
//

import UIKit
import QuartzCore

/// Manages 120Hz ProMotion display synchronization, adaptive frame pacing,
/// and battery-efficient frame rate throttling across all iPhones and iPads.
public final class HighRefreshRateManager {

    public static let shared = HighRefreshRateManager()

    private var displayLink: CADisplayLink?
    private var isProMotionAvailable: Bool = false
    private(set) var currentMaxFPS: Float = 60.0

    private init() {
        checkDisplayCapabilities()
    }

    private func checkDisplayCapabilities() {
        let maxFPS = Float(UIScreen.main.maximumFramesPerSecond)
        isProMotionAvailable = (maxFPS >= 119.0)
        currentMaxFPS = isProMotionAvailable ? maxFPS : 60.0
    }

    /// Configures the window and display link for 120Hz ProMotion with adaptive minimum bounds.
    public func enableHighRefreshRate(for window: UIWindow?) {
        guard let window = window else { return }

        // Ensure display link is synced with screen refresh cycle
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(onFrameTick))

        if #available(iOS 15.0, *) {
            if isProMotionAvailable {
                // Check if device is in Low Power Mode
                let isLowPower = ProcessInfo.processInfo.isLowPowerModeEnabled
                let targetMax: Float = isLowPower ? 60.0 : currentMaxFPS
                let targetMin: Float = 60.0 // Guaranteed minimum 60fps for butter-smooth feel

                let rateRange = CAFrameRateRange(
                    minimum: targetMin,
                    maximum: targetMax,
                    preferred: targetMax
                )
                displayLink?.preferredFrameRateRange = rateRange
                window.layer.preferredFrameRateRange = rateRange
            } else {
                let standardRange = CAFrameRateRange(minimum: 60.0, maximum: 60.0, preferred: 60.0)
                displayLink?.preferredFrameRateRange = standardRange
                window.layer.preferredFrameRateRange = standardRange
            }
        }

        displayLink?.add(to: .main, forMode: .common)
    }

    @objc private func onFrameTick() {
        // Frame pacing hook for smooth render passes
    }

    /// Adaptively throttles or restores refresh rates based on thermal/battery states
    public func updatePerformanceProfile(thermalState: ProcessInfo.ThermalState, isLowPower: Bool) {
        let targetMax: Float
        if isLowPower || thermalState == .serious || thermalState == .critical {
            // Drop to 60fps locked to prevent heat and conserve battery
            targetMax = 60.0
        } else {
            targetMax = isProMotionAvailable ? currentMaxFPS : 60.0
        }

        if #available(iOS 15.0, *), let displayLink = displayLink {
            displayLink.preferredFrameRateRange = CAFrameRateRange(
                minimum: 60.0,
                maximum: targetMax,
                preferred: targetMax
            )
        }
    }

    public func pause() {
        displayLink?.isPaused = true
    }

    public func resume() {
        displayLink?.isPaused = false
    }
}
