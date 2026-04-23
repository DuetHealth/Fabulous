// swift-tools-version:6.2

import PackageDescription

let package = Package(
    name: "Fabulous",
    platforms: [.iOS(.v13)],
    products: [.library(name: "Fabulous", targets: ["Fabulous"])],
    dependencies: [],
    targets: [
        .target(
            name: "Fabulous",
            dependencies: [],
            path: "Fabulous/Sources",
            swiftSettings: [.swiftLanguageMode(.v6)]
        )
    ]
)
