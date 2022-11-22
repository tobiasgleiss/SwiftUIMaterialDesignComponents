// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let swiftUIMDActivityIndicator = "SwiftUIMDActivityIndicator"

let package = Package(
    name: swiftUIMDActivityIndicator,
    platforms: [
        .iOS(.v14),
        .macCatalyst(.v13),
        .macOS(.v10_13),
        .tvOS(.v11),
        .watchOS(.v4)
    ],
    products: [
        .library(
            name: swiftUIMDActivityIndicator,
            targets: [swiftUIMDActivityIndicator]),
    ],
    targets: [
        .target(
            name: swiftUIMDActivityIndicator,
            dependencies: []),
    ]
)
