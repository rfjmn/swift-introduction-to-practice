// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "demo",
    dependencies: [
    ],
    targets: [
        .executableTarget(
            name: "demo",
            dependencies: []),
        .testTarget(
            name: "demoTests",
            dependencies: ["demo"]),
    ]
)
