// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RallyData",
     platforms: [
           .iOS(.v11)
       ],
       products: [
           // Products define the executables and libraries produced by a package, and make them visible to other packages.
           .library(
               name: "RallyData",
               targets: ["RallyData"]),
       ],
       dependencies: [
           .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.1.0" ),
           .package(url: "https://github.com/Swinject/Swinject.git", from: "2.7.1"),
           .package(url: "https://github.com/ashleymills/Reachability.swift.git", from: "5.0.0"),
           .package(path: "../RallyMock"),
           .package(path: "../RallyCore"),
       ],
       targets: [
           // Targets are the basic building blocks of a package. A target can define a module or a test suite.
           // Targets can depend on other targets in this package, and on products in packages which this package depends on.
           .target(
               name: "RallyData",
               dependencies: ["RxSwift", "RallyCore", "Swinject", "Reachability"]),
           .testTarget(
               name: "RallyDataTests",
               dependencies: ["RallyData", "RallyCore", "RallyMock", "RxBlocking", "RxSwift"]),
       ]
)
