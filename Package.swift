// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPackageLinter",
    
    platforms: [                    // ✅ REMOVED the dot
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    
    // 3️⃣ PRODUCTS - What this package provides to users
    products: [                     // ✅ Added space after colon
        .executable(
            name: "swift-package-linter",
            targets: ["SwiftPackageLinter"]
        )
    ],
    
    // 4️⃣ DEPENDENCIES - External packages this package depends on
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            from: "1.2.0"
        ),
    ],

    // 5️⃣ TARGETS - The basic building blocks of a package
    targets: [                      // ✅ Added space after colon
        .executableTarget(
            name: "SwiftPackageLinter",
            dependencies: [
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser"
                )
            ],
            resources: [
                .copy("Resources/Binaries"),
                .copy("Resources/Configs")
            ]
        ),
    ]
)