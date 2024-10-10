// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Helical",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "Helical", targets: ["Helical"]),
        .executable(name: "Helical-Demo", targets: ["Demo"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tomasf/SwiftSCAD.git", from: "0.7.1"),
    ],
    targets: [
        .target(
            name: "Helical",
            dependencies: ["SwiftSCAD"],
            swiftSettings: [.enableUpcomingFeature("ExistentialAny")]
        ),
        .executableTarget(
            name: "Demo",
            dependencies: ["SwiftSCAD", "Helical"],
            swiftSettings: [.enableUpcomingFeature("ExistentialAny")]
        )
    ]
)
