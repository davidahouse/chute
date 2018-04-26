//
//  DerivedData.swift
//  chute
//
//  Created by David House on 9/3/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class DerivedData {

    var derivedDataURL: URL?
    let projectFileURL: URL
    
    lazy var mostRecentTestSummary: TestSummaryFolder? = {
        guard let rootURL = derivedDataURL else {
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
            let rootURL = userPathURL.appendingPathComponents(["Library", "Developer", "Xcode", "DerivedData"])
            
            if let paths = try? FileManager.default.contentsOfDirectory(atPath: rootURL.path) {
                for path in paths {
                    let url = rootURL.appendingPathComponent(path).appendingPathComponent("info.plist")
                    if let plist = InfoPlist.from(file: url) {
                        if plist.workspacePath == projectFileURL.path  {
                            derivedDataURL = rootURL.appendingPathComponent(path)
                        } else {
                            print("Found info.plist but workspacePath was \(plist.workspacePath)")
                        }
                    }
                }
            }
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
        print("Derived Data URL: \(derivedDataURL?.path ?? "")")
        if let testSummaryFolder = mostRecentTestSummary {
            print("Test Summary:")
            testSummaryFolder.printOut()
        } else {
            print("No test summary found")
        }
    }
}
