// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "BedTimerKit",
    platforms: [
        .iOS(.v17),
        .watchOS(.v10)
    ],
    products: [
        .library(
            name: "BedTimerKit",
            targets: ["BedTimerKit"]
        ),
    ],
    dependencies: [
        // Add external dependencies here if needed
    ],
    targets: [
        .target(
            name: "BedTimerKit",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "BedTimerKitTests",
            dependencies: ["BedTimerKit"],
            path: "Tests"
        ),
    ]
)