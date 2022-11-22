// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let swiftUIMDActivityIndicator = "SwiftUIMDActivityIndicator"

let package = Package(
    name: swiftUIMDActivityIndicator,
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: swiftUIMDActivityIndicator,
            targets: [swiftUIMDActivityIndicator]),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: swiftUIMDActivityIndicator,
            dependencies: []),
    ]
)
