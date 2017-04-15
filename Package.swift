// swift-tools-version:3.1
import PackageDescription

let package = Package(
  name: "todo",
  targets: [
    Target(name: "todo", dependencies: ["TaskManagement"]),
    Target(name: "TaskManagement"),
  ],
  dependencies: [
    .Package(url: "https://github.com/kylef/Commander.git", majorVersion: 0),
  ]
)
