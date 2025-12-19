// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AudioFlashcardApp",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "AudioFlashcardApp",
            targets: ["AudioFlashcardApp"]
        )
    ],
    targets: [
        .target(
            name: "AudioFlashcardApp",
            resources: [
                .process("Resources/verbs_top_1000.json")
            ]
        )
    ]
)
