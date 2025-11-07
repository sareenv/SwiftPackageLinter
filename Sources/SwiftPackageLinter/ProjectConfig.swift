import Foundation

// Define the ProjectConfig struct
struct ProjectConfig {
    let name: String
    let swiftLintVersion: String
    let configFileName: String
}

// Project enum
enum Project: String, CaseIterable {
    case goblr = "Goblr"
    case goblrModels = "GoblrModels"
    case goblrNetworkingKit = "GoblrNetworkingKit"
    case goblrDesignKit = "GoblrDesignKit"
    
    var config: ProjectConfig {
        switch self {
        case .goblr:
            return ProjectConfig(
                name: "Goblr",
                swiftLintVersion: "0.61.0",
                configFileName: "goblr.yml"
            )
        case .goblrModels:
            return ProjectConfig(
                name: "GoblrModels",
                swiftLintVersion: "0.62.2",
                configFileName: "goblrmodels.yml"
            )
        case .goblrNetworkingKit:
            return ProjectConfig(
                name: "GoblrNetworkingKit",
                swiftLintVersion: "0.61.0",
                configFileName: "goblrnetworkingkit.yml"
            )
        case .goblrDesignKit:
            return ProjectConfig(
                name: "GoblrDesignKit",
                swiftLintVersion: "0.61.0",
                configFileName: "goblrdesignkit.yml"
            )
        }
    }
}