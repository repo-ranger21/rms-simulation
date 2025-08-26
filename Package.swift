// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CivicAI",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "CivicAI",
            targets: ["CivicAI"]),
        .executable(
            name: "CivicAIApp",
            targets: ["CivicAI"])
    ],
    dependencies: [
        // Add dependencies here if needed
    ],
    targets: [
        .target(
            name: "CivicAI",
            dependencies: [],
            resources: [
                // Add resources here if needed
            ]),
        .testTarget(
            name: "CivicAITests",
            dependencies: ["CivicAI"]),
    ]
)