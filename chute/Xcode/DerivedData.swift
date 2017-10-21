//
//  DerivedData.swift
//  chute
//
//  Created by David House on 9/3/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class DerivedData {

    static func pathFor(project: String) -> URL? {

        let userPath = NSHomeDirectory()
        let userPathURL = URL(fileURLWithPath: userPath)
        let rootURL = userPathURL.appendingPathComponents(["Library", "Developer", "Xcode", "DerivedData"])
        if let paths = try? FileManager.default.contentsOfDirectory(atPath: rootURL.path) {

            for path in paths {
                let url = rootURL.appendingPathComponent(path).appendingPathComponent("info.plist")
                print("plist \(url)")
                if let plist = InfoPlist.from(file: url) {
                    print("plist.workspacePath = \(plist.workspacePath)")
                    if plist.workspacePath == project {
                        print(path)
                        return rootURL.appendingPathComponent(path)
                    }
                }
            }
        }
        return nil
    }

    static func recentTestSummary(projectFolder: URL) -> TestSummaryFolder? {

        let summaries = TestSummary.summaries(in: projectFolder)
        if let recentSummary = summaries.sorted(by: {$0.createDate > $1.createDate}).first {
            return recentSummary
        }
        return nil
    }
}
