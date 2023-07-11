// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "DivKitPro",
  platforms: [
    .iOS(.v11),
  ],
  products: [
    .library(name: "DivKitPro", targets: ["WrapperForDivKitPro"]),
  ],
  dependencies: [
    .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.2.0"),
    .package(url: "https://github.com/divkit/divkit-ios.git", from: "26.0.0"),
  ],
  targets: [
    .binaryTarget(
      name: "DivKitPro",
      url: "https://div-storage.s3.yandex.net/releases/DivKitPro.xcframework_1.1.0.zip",
      checksum: "14cd6bad3500cc8f127a0a6e6ca04ffdf65edb1809b7a57d6df0c6fe42520e65"
    ),
    .target(
      name: "WrapperForDivKitPro",
      dependencies: [
        .target(name: "DivKitPro"),
        .product(name: "DivKit", package: "divkit-ios"),
        .product(name: "DivKitExtensions", package: "divkit-ios"),
        .product(name: "Lottie", package: "lottie-ios"),
      ],
      path: "wrapper-library-ios"
    ),
  ]
)
