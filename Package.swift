import PackageDescription

let package = Package(
    name: "Todo",
    dependencies: [
        .Package(url: "https://github.com/kylef/Commander.git",
                 majorVersion: 0, minor: 6),
    ]
)
// package.products << Product(name: "Todo", type: .Library(.Dynamic), modules: "todo")
