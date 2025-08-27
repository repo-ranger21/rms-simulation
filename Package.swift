// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "CivicAI",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(name: "CivicAI", targets: ["CivicAI"])
    ],
    dependencies: [
        .package(url: "https://github.com/supabase/supabase-swift", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "CivicAI",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "CivicAITests",
            dependencies: ["CivicAI"],
            path: "Tests"
        )
    ]
)