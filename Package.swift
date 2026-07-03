// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "pkljar",
    // Whisker (the TUI layer) sets a macOS 13 minimum, so mirror that here.
    // This is only a minimum-deployment target — it does not restrict the
    // package to macOS; pkljar builds and runs on Linux too.
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "pkljar", targets: ["pkljar"]),
        .library(name: "PkljarCore", targets: ["PkljarCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
        // swift-whisker is not versioned yet, so we track the main branch.
        .package(url: "https://github.com/ProJedi1234/swift-whisker.git", branch: "main"),
    ],
    targets: [
        .executableTarget(
            name: "pkljar",
            dependencies: [
                "PkljarCore",
                "PkljarTUI",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .target(
            name: "PkljarCore"
        ),
        .target(
            name: "PkljarTUI",
            dependencies: [
                "PkljarCore",
                .product(name: "Whisker", package: "swift-whisker"),
            ]
        ),
        .testTarget(
            name: "pkljarTests",
            dependencies: ["PkljarCore"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
