//
//  TestInfo.swift
//  chute
//
//  Created by David House on 11/2/18.
//  Copyright © 2018 David House. All rights reserved.
//

import Foundation

struct TestInfoActionResult: Decodable {
    let analyzerWarningCount: Int
    let codeCoverageArchivePath: String?
    let codeCoveragePath: String?
    let logPath: String
    let testSummaryPath: String

    enum CodingKeys: String, CodingKey {
        case analyzerWarningCount = "AnalyzerWarningCount"
        case codeCoverageArchivePath = "CodeCoverageArchivePath"
        case codeCoveragePath = "CodeCoveragePath"
        case logPath = "LogPath"
        case testSummaryPath = "TestSummaryPath"
    }
}

struct TestInfoAction: Decodable {
    let result: TestInfoActionResult

    enum CodingKeys: String, CodingKey {
        case result = "ActionResult"
    }
}

struct TestInfo: Decodable {
    let analyzerWarningCount: Int
    let errorCount: Int
    let testsCount: Int
    let testsFailedCount: Int
    let warningCount: Int
    let actions: [TestInfoAction]

    enum CodingKeys: String, CodingKey {
        case analyzerWarningCount = "AnalyzerWarningCount"
        case errorCount = "ErrorCount"
        case testsCount = "TestsCount"
        case testsFailedCount = "TestsFailedCount"
        case warningCount = "WarningCount"
        case actions = "Actions"
    }
}

extension TestInfo {
    static func from(file: URL) -> TestInfo? {
        if let data = try? Data(contentsOf: file) {
            let decoder = PropertyListDecoder()
            do {
                let plist = try decoder.decode(TestInfo.self, from: data)
                return plist
            } catch {
                print("Error attempting to decode test info file \(file.path): \(error)")
                print("Full contents of the file:")
                let dataString = String(data: data, encoding: .utf8)
                print("\(dataString ?? "")")
            }
        }
        return nil
    }
}
