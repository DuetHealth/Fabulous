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
            dependencies: ["FabulousObjc"],
            path: "Fabulous/Sources/Swift"),
        .target(
            name: "FabulousObjc",
            dependencies: [],
            path: "Fabulous/Sources/Objc")]
)
