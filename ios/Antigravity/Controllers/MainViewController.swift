//
//  MainViewController.swift
//  Antigravity for iOS / iPadOS
//

import UIKit
import WebKit

public final class MainViewController: UIViewController, WebScriptBridgeDelegate {

    private var webView: WKWebView!
    private var splashView: NativeSplashView!
    private let scriptBridge = WebScriptBridge()
    private var schemeHandler: LocalSchemeHandler?

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.043, green: 0.055, blue: 0.09, alpha: 1.0)

        setupWebView()
        setupSplash()
        setupManagers()
        loadApplication()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HighRefreshRateManager.shared.enableHighRefreshRate(for: view.window)
    }

    private func setupWebView() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        // Register custom scheme handler
        let bundleWebURL = Bundle.main.bundleURL.appendingPathComponent("web")
        let fallbackWebURL = Bundle.main.resourceURL?.appendingPathComponent("web") ?? bundleWebURL
        let targetWebURL = FileManager.default.fileExists(atPath: bundleWebURL.path) ? bundleWebURL : fallbackWebURL

        let handler = LocalSchemeHandler(webRootURL: targetWebURL)
        self.schemeHandler = handler
        config.setURLSchemeHandler(handler, forURLScheme: "antigravity")

        // User Content Controller & Bridge
        let contentController = WKUserContentController()
        scriptBridge.delegate = self
        contentController.add(scriptBridge, name: "iOS")
        contentController.add(scriptBridge, name: "Android")

        let bridgeScript = WKUserScript(
            source: WebScriptBridge.injectionScript,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )
        contentController.addUserScript(bridgeScript)
        config.userContentController = contentController

        // Enable WebKit developer tools in debug
        #if DEBUG
        if #available(iOS 16.4, *) {
            config.preferences.isElementFullscreenEnabled = true
        }
        #endif

        webView = WKWebView(frame: view.bounds, configuration: config)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.scrollView.bounces = false
        webView.scrollView.decelerationRate = .normal

        #if DEBUG
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        #endif

        view.addSubview(webView)
    }

    private func setupSplash() {
        splashView = NativeSplashView(isDark: true)
        splashView.frame = view.bounds
        splashView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(splashView)
    }

    private func setupManagers() {
        ThermalBatteryManager.shared.configure(with: webView)
    }

    private func loadApplication() {
        // First try antigravity://app/index.html via custom scheme
        if let url = URL(string: "antigravity://app/index.html") {
            webView.load(URLRequest(url: url))
        }

        // Safety watchdog: auto-dismiss splash after 6 seconds if bridge event was delayed
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) { [weak self] in
            self?.bridgeDidReceiveUiReady()
        }
    }

    // MARK: - WebScriptBridgeDelegate

    public func bridgeDidReceiveUiReady() {
        splashView?.dismiss()
    }

    public func bridgeDidRequestDirectoryPicker() {
        DocumentPickerManager.shared.pickFolder(from: self) { [weak self] selectedPath in
            guard let self = self else { return }
            let jsArg = selectedPath != nil ? "'\(selectedPath!)'" : "null"
            let js = "window.__onDirectoryPicked && window.__onDirectoryPicked(\(jsArg));"
            self.webView.evaluateJavaScript(js, completionHandler: nil)
        }
    }

    public func bridgeDidRequestSaveBlob(base64Data: String, filename: String, mimeType: String) {
        guard let data = Data(base64Encoded: base64Data) else { return }
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        do {
            try data.write(to: tempURL)
            let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = self.view
                popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            present(activityVC, animated: true)
        } catch {
            print("Failed to save blob: \(error)")
        }
    }

    public func bridgeDidChangeTheme(isDark: Bool) {
        view.backgroundColor = isDark ? UIColor(red: 0.043, green: 0.055, blue: 0.09, alpha: 1.0) : .white
        setNeedsStatusBarAppearanceUpdate()
    }

    public func bridgeDidChangeDesktopMode(enabled: Bool) {
        // Dynamic viewport update
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override public var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
}
