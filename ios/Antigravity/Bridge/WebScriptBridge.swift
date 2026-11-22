//
//  WebScriptBridge.swift
//  Antigravity for iOS / iPadOS
//

import UIKit
import WebKit

protocol WebScriptBridgeDelegate: AnyObject {
    func bridgeDidReceiveUiReady()
    func bridgeDidRequestDirectoryPicker()
    func bridgeDidRequestSaveBlob(base64Data: String, filename: String, mimeType: String)
    func bridgeDidChangeTheme(isDark: Bool)
    func bridgeDidChangeDesktopMode(enabled: Bool)
}

/// Provides bidirectional communication between WebKit and Swift, polyfilling
/// both `window.Android` and `window.iOS` interfaces.
public final class WebScriptBridge: NSObject, WKScriptMessageHandler {

    weak var delegate: WebScriptBridgeDelegate?

    public static let injectionScript: String = """
    (function() {
        if (window.__agIOSBridgeInjected) return;
        window.__agIOSBridgeInjected = true;

        // Bridge handler for iOS native message handler
        function postNative(action, payload) {
            try {
                var message = Object.assign({ action: action }, payload || {});
                if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.iOS) {
                    window.webkit.messageHandlers.iOS.postMessage(message);
                } else if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.Android) {
                    window.webkit.messageHandlers.Android.postMessage(message);
                }
            } catch (e) {
                console.error('Bridge dispatch error:', e);
            }
        }

        // Universal Android & iOS interface polyfill
        var bridge = {
            onUiReady: function(token) {
                postNative('onUiReady', { token: token });
            },
            openDirectoryPicker: function() {
                postNative('openDirectoryPicker');
            },
            onUiError: function(token, error) {
                postNative('onUiError', { token: token, error: error });
            },
            setTheme: function(theme) {
                postNative('setTheme', { theme: theme });
                return true;
            },
            setThemeByUser: function(theme) {
                postNative('setThemeByUser', { theme: theme });
                return true;
            },
            getTheme: function() {
                return window.__agHostTheme || 'dark';
            },
            isDesktopMode: function() {
                var isIPad = /iPad/.test(navigator.userAgent) || (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1);
                var stored = localStorage.getItem('ag_desktop_mode');
                return stored !== null ? (stored === 'true') : isIPad;
            },
            setDesktopMode: function(enabled) {
                try { localStorage.setItem('ag_desktop_mode', String(enabled)); } catch(_) {}
                postNative('setDesktopMode', { enabled: enabled });
            },
            saveBlob: function(token, base64, filename, mime) {
                postNative('saveBlob', { token: token, data: base64, filename: filename, mime: mime });
            }
        };

        window.Android = bridge;
        window.iOS = bridge;

        // 120Hz smooth touch & gesture enhancements
        var style = document.createElement('style');
        style.setAttribute('data-agy-ios', 'motion-polish');
        style.textContent = `
            * {
                -webkit-tap-highlight-color: transparent;
                -webkit-touch-callout: none;
            }
            main, [data-testid="chat-container"], .scrollable, body {
                -webkit-overflow-scrolling: touch !important;
                scroll-behavior: smooth !important;
            }
            button:active, [role="button"]:active {
                transform: scale(0.975);
                transition: transform 90ms cubic-bezier(0, 0, 0.2, 1);
            }
        `;
        (document.head || document.documentElement).appendChild(style);
    })();
    """

    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: Any],
              let action = body["action"] as? String else { return }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch action {
            case "onUiReady":
                self.delegate?.bridgeDidReceiveUiReady()
            case "openDirectoryPicker":
                self.delegate?.bridgeDidRequestDirectoryPicker()
            case "saveBlob":
                let data = body["data"] as? String ?? ""
                let filename = body["filename"] as? String ?? "download"
                let mime = body["mime"] as? String ?? "application/octet-stream"
                self.delegate?.bridgeDidRequestSaveBlob(base64Data: data, filename: filename, mimeType: mime)
            case "setTheme", "setThemeByUser":
                let theme = body["theme"] as? String ?? "dark"
                self.delegate?.bridgeDidChangeTheme(isDark: theme == "dark")
            case "setDesktopMode":
                let enabled = body["enabled"] as? Bool ?? false
                self.delegate?.bridgeDidChangeDesktopMode(enabled: enabled)
            default:
                break
            }
        }
    }
}
