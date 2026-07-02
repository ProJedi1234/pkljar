// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "pkljar",
    products: [
        .executable(name: "pkljar", targets: ["pkljar"]),
        .library(name: "PkljarCore", targets: ["PkljarCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
    ],
    targets: [
        .executableTarget(
            name: "pkljar",
            dependencies: [
                "PkljarCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .target(
            name: "PkljarCore"
        ),
        .testTarget(
            name: "pkljarTests",
            dependencies: ["PkljarCore"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
