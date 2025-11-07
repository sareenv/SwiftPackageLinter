import ArgumentParser
import Foundation

@main
struct SwiftPackageLinterCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "swift-package-linter",
        abstract: "Lint Swift projects with project-specific SwiftLint versions"
    )
    
    @Argument(help: "Project name (Goblr, GoblrModels, GoblrNetworkingKit, GoblrDesignKit)")
    var projectName: String
    
    @Option(name: .shortAndLong, help: "Path to the project directory")
    var path: String?
    
    func run() throws {
        // Parse project
        guard let project = Project(rawValue: projectName) else {
            print("❌ Unknown project: \(projectName)")
            print("\nAvailable projects:")
            Project.allCases.forEach { print("  • \($0.rawValue)") }
            throw ExitCode.failure
        }
        
        // Determine path
        let projectPath = path ?? FileManager.default.currentDirectoryPath
        
        // Verify path exists
        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: projectPath, isDirectory: &isDirectory),
              isDirectory.boolValue else {
            print("❌ Invalid project path: \(projectPath)")
            throw ExitCode.failure
        }
        
        // Run linter
        let linter = Linter(project: project, projectPath: projectPath)
        try linter.run()
    }
}