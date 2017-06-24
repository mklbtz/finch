// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "Finch",
  products: [
    .executable(name: "finch", targets: ["finch"]),
    .executable(name: "finch-file", targets: ["finch-file"]),
    .library(name: "TaskManagement", targets: ["TaskManagement"])
  ],
  dependencies: [
    .package(url: "https://github.com/Carthage/Commandant.git", .branch("master")),
  ],
  targets: [
    .target(name: "finch", dependencies: ["TaskManagement", "Commandant"]),
    .target(name: "finch-file", dependencies: ["TaskManagement", "Commandant"]),
    .target(name: "TaskManagement"),
  ],
  swiftLanguageVersions: [3, 4]
)
