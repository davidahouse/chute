//
//  DerivedData.swift
//  chute
//
//  Created by David House on 9/3/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class DerivedData {

    let derivedDataURL: URL
    let projectFileURL: URL
    lazy var rootURL: URL? = {
        if let paths = try? FileManager.default.contentsOfDirectory(atPath: self.derivedDataURL.path) {
            
            // First check root of derivedData for info.plist
            let url = derivedDataURL.appendingPathComponent("info.plist")
            if let plist = InfoPlist.from(file: url) {
                if plist.workspacePath == projectFileURL.path {
                    return derivedDataURL
                }
            }
            
            for path in paths {
                let url = derivedDataURL.appendingPathComponent(path).appendingPathComponent("info.plist")
                if let plist = InfoPlist.from(file: url) {
                    if plist.workspacePath == projectFileURL.path {
                        return derivedDataURL.appendingPathComponent(path)
                    }
                }
            }
        }
        return nil
    }()
    
    lazy var mostRecentTestSummary: TestSummaryFolder? = {
        guard let rootURL = self.rootURL else {
            return nil
        }
        
        let summaries = TestSummary.summaries(in: rootURL)
        if let recentSummary = summaries.sorted(by: {$0.createDate > $1.createDate}).first {
            return recentSummary
        }
        return nil
    }()
    
    init(projectFileURL: URL, derivedDataFolder: String?) {
        
        if let derivedDataFolder = derivedDataFolder {
            derivedDataURL = URL(fileURLWithPath: derivedDataFolder)
        } else {
            let userPath = NSHomeDirectory()
            let userPathURL = URL(fileURLWithPath: userPath)
            derivedDataURL = userPathURL.appendingPathComponents(["Library", "Developer", "Xcode", "DerivedData"])
        }
        self.projectFileURL = projectFileURL
    }

    static func recentTestSummary(projectFolder: URL) -> TestSummaryFolder? {

        let summaries = TestSummary.summaries(in: projectFolder)
        if let recentSummary = summaries.sorted(by: {$0.createDate > $1.createDate}).first {
            return recentSummary
        }
        return nil
    }
}

extension DerivedData: Printable {
    
    func printOut() {
        print("Derived Data URL: \(derivedDataURL.path)")
        print("Derived Data Project URL: \(rootURL?.path ?? "")")
        if let testSummaryFolder = mostRecentTestSummary {
            print("Test Summary:")
            testSummaryFolder.printOut()
        } else {
            print("No test summary found")
        }
    }
}
