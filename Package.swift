// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Helical",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "Helical", targets: ["Helical"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tomasf/SwiftSCAD.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Helical",
            dependencies: ["SwiftSCAD"],
            swiftSettings: [.enableUpcomingFeature("ExistentialAny")]
        )
    ]
)
