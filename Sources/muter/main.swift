import Darwin
import Foundation
import muterCore

enum MuterError: Error {
    case configurationError
}

if #available(OSX 10.13, *) {
    let fileManager = FileManager.default
    let currentDirectoryPath = fileManager.currentDirectoryPath

    let (exitCode, message) = handle(
        commandlineArguments: CommandLine.arguments, 
        setup: {
            try setupMuter(using: fileManager, and: currentDirectoryPath)
        }, 
        run: {
            let configurationPath = currentDirectoryPath + "/muter.conf.json"
            
            guard let configurationData = fileManager.contents(atPath: configurationPath) else {
                throw MuterError.configurationError
            }

            let configuration = try JSONDecoder().decode(MuterConfiguration.self, from: configurationData)
            run(with: configuration, in: currentDirectoryPath)
        }
    )

    print(message ?? "")
    exit(exitCode)
} else {
    print("Muter requires macOS 10.13 or higher")
    exit(1)
}
