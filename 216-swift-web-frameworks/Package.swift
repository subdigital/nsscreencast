import PackageDescription

let package = Package(
  name: "HelloWorld",
  dependencies: [
  .Package(url: "https://github.com/nestproject/Frank.git", majorVersion: 0, minor: 2),
  .Package(url: "https://github.com/kylef/Stencil", majorVersion: 0),
  .Package(url: "https://github.com/czechboy0/Jay.git", Version(0, 3, 5))
])
