// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "JugLotterySwift",
    products: [
        .library(name: "App", targets: ["App"]),
        .executable(name: "Run", targets: ["Run"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .exact("2.4.4")),
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor"],
                exclude: [
                    "Config",
                    "Public",
                    "Resources",
                ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App", "Testing"])
    ]
)

