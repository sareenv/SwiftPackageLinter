# SwiftPackageLinter

A Swift package for linting projects with project-specific SwiftLint versions and configurations.

## What It Does

- Runs SwiftLint with different versions for different projects
- Uses project-specific lint rules
- Bundles binaries - no system installation needed

## Projects

- **Goblr** - SwiftLint 0.61.0
- **GoblrModels** - SwiftLint 0.62.2
- **GoblrNetworkingKit** - SwiftLint 0.61.0
- **GoblrDesignKit** - SwiftLint 0.61.0

## Usage
```bash
# Run from your iOS project directory
swift run --package-path /path/to/SwiftPackageLinter swift-package-linter <ProjectName> --path <path>
```

## Examples
```bash
# Lint Goblr
swift run --package-path ~/SwiftPackageLinter swift-package-linter Goblr --path ./Goblr

# Lint GoblrModels
swift run --package-path ~/SwiftPackageLinter swift-package-linter GoblrModels --path ./GoblrModels
```

## Adding to Your Project

Add as a dependency in your iOS project's Package.swift:
```swift
dependencies: [
    .package(url: "https://github.com/sareenv/SwiftPackageLinter", branch: "main")
]
```

## Updating Rules

Edit config files in `Sources/SwiftPackageLinter/Resources/Configs/`

## Updating SwiftLint Versions

1. Download new binary from [SwiftLint Releases](https://github.com/realm/SwiftLint/releases)
2. Rename to `swiftlint-X.Y.Z`
3. Place in `Sources/SwiftPackageLinter/Resources/Binaries/`
4. Run `chmod +x` on the binary
5. Update version in `ProjectConfig.swift`