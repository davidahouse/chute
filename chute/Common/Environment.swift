//
//  Environment.swift
//  chute
//
//  Created by David House on 11/15/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class Environment {
    
    let arguments: CommandLineArguments
    let projectFileURL: URL?
    let derivedData: DerivedData?
    
    lazy var hasValidEnvironment: Bool = {
        
        guard arguments.project != nil, let projectFileURL = self.projectFileURL, FileManager.default.fileExists(atPath: projectFileURL.path) else {
            return false
        }
        
        guard derivedData != nil else {
            return false
        }
        
        return true
    }()
    
    init(arguments: CommandLineArguments) {

        self.arguments = arguments
        guard let project = arguments.project else  {
            self.projectFileURL = nil
            self.derivedData = nil
            return
        }
        let projectFileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(project)
        self.projectFileURL = projectFileURL

        self.derivedData = DerivedData(projectFileURL: projectFileURL, derivedDataFolder: arguments.derivedDataFolder)
    }
}

extension Environment: Printable {

    func printOut() {
        print("Project File: \(projectFileURL?.path ?? "")")
        if let derivedData = derivedData {
            derivedData.printOut()
        } else {
            print("Derived Data: not found")
        }
    }
}
