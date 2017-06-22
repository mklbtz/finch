// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "todo",
  products: [
    .executable(name: "todo", targets: ["todo"]),
    .library(name: "TaskManagement", targets: ["TaskManagement"])
  ],
  dependencies: [
    .package(url: "https://github.com/Carthage/Commandant.git", .branch("master")),
  ],
  targets: [
    .target(name: "todo", dependencies: ["TaskManagement", "Commandant"]),
    .target(name: "TaskManagement"),
  ],
  swiftLanguageVersions: [3, 4]
)
