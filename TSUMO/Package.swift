// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TSUMO",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TSUMO",
            targets: ["TSUMO"]),
    ],
    dependencies: [
        // Firebase dependencies will be added here
    ],
    targets: [
        .target(
            name: "TSUMO",
            dependencies: []),
        .testTarget(
            name: "TSUMOTests",
            dependencies: ["TSUMO"]),
    ]
)
