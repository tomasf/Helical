// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Helical",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "Helical", targets: ["Helical"]),
        .executable(name: "Helical-Demo", targets: ["Demo"]),
    ],
    dependencies: [
        .package(path: "../Cadova"),
        //.package(url: "https://github.com/tomasf/Cadova.git", .upToNextMinor(from: "0.5.0")),
    ],
    targets: [
        .target(
            name: "Helical",
            dependencies: ["Cadova"],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),
        .executableTarget(
            name: "Demo",
            dependencies: ["Cadova", "Helical"],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        )
    ]
)
