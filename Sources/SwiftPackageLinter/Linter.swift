import Foundation

struct Linter {
    let project: Project
    let projectPath: String
    
    func run() throws {
        let config = project.config
        
        print("🔍 Linting \(config.name)")
        print("📦 Using SwiftLint version: \(config.swiftLintVersion)")
        
        // Get the binary path
        guard let binaryPath = getBinaryPath(version: config.swiftLintVersion) else {
            throw LinterError.binaryNotFound(config.swiftLintVersion)
        }
        
        print("🔧 Binary: \(binaryPath)")
        
        // Get the config path
        guard let configPath = getConfigPath(fileName: config.configFileName) else {
            throw LinterError.configNotFound(config.configFileName)
        }
        
        print("📋 Config: \(configPath)")
        
        // Run SwiftLint
        try runSwiftLint(binaryPath: binaryPath, configPath: configPath)
        
        print("✅ Linting completed!")
    }
    
    private func getBinaryPath(version: String) -> String? {
        // For executable targets, resources are in a different location
        let fileManager = FileManager.default
        
        // Try to find resources relative to the executable
        #if DEBUG
            // In debug mode, look in the source directory
            let currentPath = fileManager.currentDirectoryPath
            let binaryPath = "\(currentPath)/Sources/SwiftPackageLinter/Resources/Binaries/swiftlint-\(version)"
        #else
        // In release mode, resources should be bundled
        guard let executablePath = Bundle.main.executablePath else {
            return nil
        }
        let executableDir = (executablePath as NSString).deletingLastPathComponent
        let binaryPath = "\(executableDir)/../Resources/Binaries/swiftlint-\(version)"
        #endif
        
        guard fileManager.fileExists(atPath: binaryPath),
            fileManager.isExecutableFile(atPath: binaryPath) else {
            return nil
        }
        return binaryPath
    }
    
    private func getConfigPath(fileName: String) -> String? {
        let fileManager = FileManager.default
        
        #if DEBUG
        // In debug mode, look in the source directory
        let currentPath = fileManager.currentDirectoryPath
        let configPath = "\(currentPath)/Sources/SwiftPackageLinter/Resources/Configs/\(fileName)"
        #else
        // In release mode, resources should be bundled
        guard let executablePath = Bundle.main.executablePath else {
            return nil
        }
        let executableDir = (executablePath as NSString).deletingLastPathComponent
        let configPath = "\(executableDir)/../Resources/Configs/\(fileName)"
        #endif
        
        guard fileManager.fileExists(atPath: configPath) else {
            return nil
        }
        
        return configPath
    }
    
    private func runSwiftLint(binaryPath: String, configPath: String) throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: binaryPath)
        process.arguments = [
            "lint",
            "--config", configPath,
            "--path", projectPath
        ]
        
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        try process.run()
        process.waitUntilExit()
        
        // Print output
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: outputData, encoding: .utf8) {
            print(output)
        }
        
        // Print errors
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        if let error = String(data: errorData, encoding: .utf8), !error.isEmpty {
            print(error)
        }
    }
}

enum LinterError: Error, CustomStringConvertible {
    case binaryNotFound(String)
    case configNotFound(String)
    case invalidProjectPath
    
    var description: String {
        switch self {
        case .binaryNotFound(let version):
            return "❌ SwiftLint binary not found for version: \(version)"
        case .configNotFound(let fileName):
            return "❌ Config file not found: \(fileName)"
        case .invalidProjectPath:
            return "❌ Invalid project path"
        }
    }
}