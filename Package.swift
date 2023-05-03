// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "npush",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "npush",
            targets: ["npush"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "npush",
            dependencies: []
        ),
        .testTarget(
            name: "npushTests",
            dependencies: [ "npush"]
        ),
    ]
)
