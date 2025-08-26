// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "RMSSimulation",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "RMSSimulation",
            targets: ["RMSSimulation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/supabase/supabase-swift", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "RMSSimulation",
            dependencies: [
                .product(name: "Supabase", package: "supabase-swift"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals")
            ]),
        .testTarget(
            name: "RMSSimulationTests",
            dependencies: ["RMSSimulation"]),
    ]
)