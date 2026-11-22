// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "Antigravity",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Antigravity",
            targets: ["Antigravity"]
        ),
    ],
    targets: [
        .target(
            name: "Antigravity",
            path: "Antigravity"
        ),
    ]
)
