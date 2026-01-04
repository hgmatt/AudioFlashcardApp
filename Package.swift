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
        ),
        .iOSApplication(
            name: "AudioFlashcardApp",
            targets: ["AudioFlashcardApp"],
            bundleIdentifier: "com.audioflashcard.app",
            teamIdentifier: nil,
            displayVersion: "1.0",
            bundleVersion: "1",
            iconAssetName: nil,
            accentColorAssetName: nil,
            supportedDeviceFamilies: [.pad, .phone],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeLeft,
                .landscapeRight
            ]
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
