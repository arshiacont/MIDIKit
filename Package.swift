// swift-tools-version:5.5
// (be sure to update the .swift-version file when this Swift version changes)

import PackageDescription

let package = Package(
    name: "MIDIKit",
    
    platforms: [
        .macOS(.v10_12), .iOS(.v10)
    ],
    
    products: [
        .library(
            name: "MIDIKit",
            type: .static,
            targets: ["MIDIKit"]
        ),
//        .library(
//            name: "MIDIKitCommon",
//            type: .static,
//            targets: ["MIDIKitCommon"]
//        ),
//        .library(
//            name: "MIDIKitEvents",
//            type: .static,
//            targets: ["MIDIKitEvents"]
//        ),
//        .library(
//            name: "MIDIKitInternals",
//            type: .static,
//            targets: ["MIDIKitInternals"]
//        ),
    ],
    
    dependencies: [
        // testing-only:
        .package(url: "https://github.com/orchetect/XCTestUtils", from: "1.0.1")
    ],
    
    targets: [
        .target(
            name: "MIDIKit",
            dependencies: [
                .target(name: "MIDIKitCommon"),
                .target(name: "MIDIKitEvents"),
                .target(name: "MIDIKitIO")
            ]
        ),
        .target(
            name: "MIDIKitInternals",
            dependencies: [
            ]
        ),
        .target(
            name: "MIDIKitCommon",
            dependencies: [
                .target(name: "MIDIKitInternals")
            ]
        ),
        .target(
            name: "MIDIKitEvents",
            dependencies: [
                .target(name: "MIDIKitCommon")
            ]
        ),
        .target(
            name: "MIDIKitIO",
            dependencies: [
                .target(name: "MIDIKitInternals"),
                .target(name: "MIDIKitCommon"),
                .target(name: "MIDIKitEvents")
            ]
        ),
        
        // test targets
        .testTarget(
            name: "MIDIKitTests",
            dependencies: [
                .target(name: "MIDIKit"),
                .product(name: "XCTestUtils", package: "XCTestUtils")
            ]
        ),
        .testTarget(
            name: "MIDIKitCommonTests",
            dependencies: [
                .target(name: "MIDIKitCommon"),
                .product(name: "XCTestUtils", package: "XCTestUtils")
            ]
        ),
        .testTarget(
            name: "MIDIKitEventsTests",
            dependencies: [
                .target(name: "MIDIKitEvents"),
                .product(name: "XCTestUtils", package: "XCTestUtils")
            ]
        ),
        .testTarget(
            name: "MIDIKitIOTests",
            dependencies: [
                .target(name: "MIDIKitIO"),
                .product(name: "XCTestUtils", package: "XCTestUtils")
            ]
        )
    ],
    
    swiftLanguageVersions: [.v5]
)

func addShouldTestFlag(toTarget targetName: String) {
    // swiftSettings may be nil so we can't directly append to it
    
    var swiftSettings = package.targets
        .first(where: { $0.name == targetName })?
        .swiftSettings ?? []
    
    swiftSettings.append(.define("shouldTestCurrentPlatform"))
    
    package.targets
        .first(where: { $0.name == targetName })?
        .swiftSettings = swiftSettings
}

func addShouldTestFlags() {
    addShouldTestFlag(toTarget: "MIDIKitTests")
    addShouldTestFlag(toTarget: "MIDIKitCommonTests")
    addShouldTestFlag(toTarget: "MIDIKitEventsTests")
    addShouldTestFlag(toTarget: "MIDIKitIOTests")
}

// Swift version in Xcode 12.5.1 which introduced watchOS testing
#if os(watchOS) && swift(>=5.4.2)
addShouldTestFlags()
#elseif os(watchOS)
// don't add flag
#else
addShouldTestFlags()
#endif
