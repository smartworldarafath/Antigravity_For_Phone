//
//  LocalSchemeHandler.swift
//  Antigravity for iOS / iPadOS
//

import Foundation
import WebKit

/// Custom URL scheme handler serving local bundled web assets under `antigravity://app/`.
public final class LocalSchemeHandler: NSObject, WKURLSchemeHandler {

    private let webRootURL: URL

    public init(webRootURL: URL) {
        self.webRootURL = webRootURL
        super.init()
    }

    public func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        guard let url = urlSchemeTask.request.url else {
            urlSchemeTask.didFailWithError(NSError(domain: "LocalSchemeHandler", code: 400, userInfo: nil))
            return
        }

        var path = url.path
        if path.isEmpty || path == "/" {
            path = "/index.html"
        }

        let relativePath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        let fileURL = webRootURL.appendingPathComponent(relativePath)

        guard FileManager.default.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL) else {
            // Fallback to index.html for single-page routing
            let indexPath = webRootURL.appendingPathComponent("index.html")
            if let indexData = try? Data(contentsOf: indexPath) {
                let response = HTTPURLResponse(
                    url: url,
                    statusCode: 200,
                    httpVersion: "HTTP/1.1",
                    headerFields: ["Content-Type": "text/html; charset=utf-8", "Access-Control-Allow-Origin": "*"]
                )!
                urlSchemeTask.didReceive(response)
                urlSchemeTask.didReceive(indexData)
                urlSchemeTask.didFinish()
                return
            }
            urlSchemeTask.didFailWithError(NSError(domain: "LocalSchemeHandler", code: 404, userInfo: nil))
            return
        }

        let mimeType = mimeType(for: fileURL.pathExtension)
        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: "HTTP/1.1",
            headerFields: [
                "Content-Type": mimeType,
                "Access-Control-Allow-Origin": "*",
                "Cache-Control": "max-age=86400"
            ]
        )!

        urlSchemeTask.didReceive(response)
        urlSchemeTask.didReceive(data)
        urlSchemeTask.didFinish()
    }

    public func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        // Task cancelled
    }

    private func mimeType(for ext: String) -> String {
        switch ext.lowercased() {
        case "html", "htm": return "text/html; charset=utf-8"
        case "js", "mjs": return "application/javascript; charset=utf-8"
        case "css": return "text/css; charset=utf-8"
        case "json": return "application/json; charset=utf-8"
        case "png": return "image/png"
        case "jpg", "jpeg": return "image/jpeg"
        case "svg": return "image/svg+xml"
        case "mp3": return "audio/mpeg"
        case "woff2": return "font/woff2"
        case "woff": return "font/woff"
        case "ttf": return "font/ttf"
        default: return "application/octet-stream"
        }
    }
}
