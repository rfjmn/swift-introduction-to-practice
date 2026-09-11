// swift-tools-version:5.5.2

import PackageDescription

let package = Package(
    name: "Example",
    targets: [
        .target(name: "Library"),
        .target(name: "AnotherLibrary", dependencies: ["Library"]),
        .testTarget(name: "ModuleTests", dependencies: ["Library", "AnotherLibrary"]),
    ]
)
