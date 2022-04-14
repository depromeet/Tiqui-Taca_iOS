// swift-tools-version:5.1
import PackageDescription

let package = Package(
  name: "BuildTools",
  dependencies: [
    .package(url: "https://github.com/mac-cain13/R.swift", from: "6.1.0"),
  ],
  targets: [.target(name: "BuildTools", path: "")]
)
