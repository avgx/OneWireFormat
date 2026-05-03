// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "OneWireFormat",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15),
        .macOS(.v13),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "OneWireFormat",
            targets: ["OneWireFormat"]
        ),
    ],
    targets: [
        .target(
            name: "OneWireFormat"
        ),
        .testTarget(
            name: "OneWireFormatTests",
            dependencies: ["OneWireFormat"]
        ),
    ]
)
