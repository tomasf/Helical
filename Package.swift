// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Helical",
    products: [
        .library(name: "Helical", targets: ["Helical"]),
        .executable(name: "Helical-Demo", targets: ["Demo"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tomasf/SwiftSCAD.git", .upToNextMinor(from: "0.8.1")),
    ],
    targets: [
        .target(name: "Helical", dependencies: ["SwiftSCAD"]),
        .executableTarget(name: "Demo", dependencies: ["SwiftSCAD", "Helical"])
    ]
)
