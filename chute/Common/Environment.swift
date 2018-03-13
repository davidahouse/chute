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
    
    // for iOS
    let derivedData: DerivedData?
    
    // for Android
    let buildFolder: BuildFolder?
    
    lazy var hasValidEnvironment: Bool = {
        
        guard arguments.project != nil, let projectFileURL = self.projectFileURL, FileManager.default.fileExists(atPath: projectFileURL.path) else {
            return false
        }
        
        if derivedData == nil && buildFolder == nil {
            return false
        }
        
        return true
    }()
    
    init(arguments: CommandLineArguments) {

        self.arguments = arguments
        guard let project = arguments.project else  {
            self.projectFileURL = nil
            self.derivedData = nil
            self.buildFolder = nil
            return
        }
        let projectFileURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(project)
        self.projectFileURL = projectFileURL

        if arguments.platform == "iOS" {
            self.derivedData = DerivedData(projectFileURL: projectFileURL, derivedDataFolder: arguments.derivedDataFolder)
            self.buildFolder = nil
        } else {
            self.buildFolder = BuildFolder(projectFileURL: projectFileURL)
            self.derivedData = nil
        }
    }
    
    func dataCapture() -> DataCapture? {
        if arguments.platform == "iOS" {
            return XcodeDataCapture(using: self)
        } else {
            return AndroidDataCapture(using: self)
        }
    }
    
    func dataCapture(from compareToFolder: String?) -> DataCapture? {
        if arguments.platform == "iOS" {
            return XcodeDataCapture(using: self, from: compareToFolder)
        } else {
            return AndroidDataCapture(using: self, from: compareToFolder)
        }
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
        if let buildFolder = buildFolder {
            buildFolder.printOut()
        } else {
            print("Build Folder: not found")
        }
    }
}
