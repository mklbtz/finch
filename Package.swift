import PackageDescription

let package = Package(
  name: "Todo",
  dependencies: [
    .Package(url: "https://github.com/kylef/Commander.git", majorVersion: 0),
    .Package(url: "https://github.com/jpsim/Yams.git", majorVersion: 0)
  ]
)
