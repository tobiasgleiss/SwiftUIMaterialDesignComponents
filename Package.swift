// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let swiftUIMaterialDesignComponents = "SwiftUIMaterialDesignComponents"

let package = Package(
    name: swiftUIMaterialDesignComponents,
    platforms: [
        .iOS(.v14),
        .macCatalyst(.v13),
        .macOS(.v10_13),
        .tvOS(.v11),
        .watchOS(.v4)
    ],
    products: [
        .library(
            name: swiftUIMaterialDesignComponents,
            targets: [swiftUIMaterialDesignComponents]),
    ],
    targets: [
        .target(
            name: swiftUIMaterialDesignComponents,
            dependencies: []),
    ]
)
