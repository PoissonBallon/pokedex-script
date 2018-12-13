// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "pokedex-script",
  dependencies: [
    .package(url: "https://github.com/vapor/console.git", from: "3.0.0"),
    .package(url: "https://github.com/vapor/http.git", from: "3.0.0"),
    .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "1.7.5")
  ],
  targets: [
    .target(name: "pokedex-script", dependencies: ["HTTP", "Console", "SwiftSoup"]),
    .testTarget(name: "pokedex-scriptTests", dependencies: ["pokedex-script"]),
    ]
)
