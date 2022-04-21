// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RallyUI",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "RallyUI",
            targets: ["RallyUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.1.0" ),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.0"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.7.1"),
        .package(url: "https://github.com/JonasGessner/JGProgressHUD.git", .branch("master")),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "5.8.0"),
        .package(path: "../RallyCore"),
        
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "RallyUI",
            dependencies: ["RallyCore", "RxSwift", "RxCocoa", "SnapKit", "Swinject", "JGProgressHUD", "Kingfisher"]),
        .testTarget(
            name: "RallyUITests",
            dependencies: ["RallyUI"]),
    ]
)
