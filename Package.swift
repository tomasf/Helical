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
        .package(path: "../Cadova")
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
