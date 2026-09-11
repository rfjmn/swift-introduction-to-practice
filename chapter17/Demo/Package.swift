// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "Demo",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Demo",
            targets: ["Demo"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Demo",
            dependencies: []),
        .testTarget(
            name: "DemoTests",
            dependencies: ["Demo"]),
    ]
)
