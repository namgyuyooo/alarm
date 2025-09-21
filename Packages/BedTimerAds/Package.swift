// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "BedTimerAds",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "BedTimerAds",
            targets: ["BedTimerAds"]
        ),
    ],
    dependencies: [
        // AdMob or Apple Ads SDK dependencies
    ],
    targets: [
        .target(
            name: "BedTimerAds",
            dependencies: [],
            path: "Sources"
        ),
    ]
)