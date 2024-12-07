// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SwiftCSVEncoder",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "SwiftCSVEncoder",
            targets: ["SwiftCSVEncoder"]),
    ],
    targets: [
        .target(
            name: "SwiftCSVEncoder"),
        .testTarget(
            name: "SwiftCSVEncoderTests",
            dependencies: ["SwiftCSVEncoder"]),
    ]
)
