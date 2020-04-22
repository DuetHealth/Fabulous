// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Fabulous",
    platforms: [.iOS(.v10)],
    products: [
        .library(
            name: "Fabulous",
            targets: ["Fabulous"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Fabulous",
            dependencies: [],
            path: "Fabulous/Sources/Swift"),
    ]
)
