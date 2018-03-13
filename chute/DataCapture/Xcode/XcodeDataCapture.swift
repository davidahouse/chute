//
//  XcodeDataCapture.swift
//  chute
//
//  Created by David House on 2/16/18.
//  Copyright © 2018 David House. All rights reserved.
//

import Foundation

struct XcodeDataCapture : DataCapture {
    
    let project: String
    let branch: String
    let testExecutionDate: Date
    
    let testResults: [ChuteTestResult]
    let codeCoverage: [ChuteCodeCoverage]
    let codeCoverageSummary: ChuteCodeCoverageSummary
    let attachments: [ChuteTestAttachment]
    let styleSheets: [ChuteStyleSheet]
    let attachmentRootURL: URL
    
    init?(using environment: Environment) {
        
        guard let testSummaryFolder = environment.derivedData?.mostRecentTestSummary else {
            return nil
        }
        
        project = environment.arguments.project ?? ""
        branch = environment.arguments.branch ?? ""
        testExecutionDate = testSummaryFolder.createDate
        testResults = ChuteTestResult.findResults(testSummary: testSummaryFolder.summary)
        attachments = ChuteTestAttachment.findAttachments(testSummary: testSummaryFolder.summary)
        styleSheets = ChuteStyleSheet.findStyleSheets(testSummary: testSummaryFolder.summary, rootPath: testSummaryFolder.attachmentRootURL)
        codeCoverage = ChuteCodeCoverage.findCodeCoverage(testSummaryURL: testSummaryFolder.summaryFileURL)
        codeCoverageSummary = ChuteCodeCoverageSummary(coverages: codeCoverage)
        attachmentRootURL = testSummaryFolder.attachmentRootURL
    }
    
    init?(using environment: Environment, from compareToFolder: String?) {
        
        guard let compareToFolder = compareToFolder else {
            return nil
        }
        
        project = environment.arguments.project ?? ""
        // TODO: Need to get the branch information from the saved data?
        branch = ""
        // TODO: Also need to capture the test execution date so it can be used later
        testExecutionDate = Date()
        
        let beforeTestSummaryURL = URL(fileURLWithPath: compareToFolder).appendingPathComponents(["source", "TestSummaries.plist"])
        guard let beforeTestSummary = TestSummary.from(file: beforeTestSummaryURL) else {
            print("Error comparing results, unabled to find TestSummary.plist in compareFolder of \(compareToFolder)")
            return nil
        }
        
        testResults = ChuteTestResult.findResults(testSummary: beforeTestSummary)
        attachments = ChuteTestAttachment.findAttachments(testSummary: beforeTestSummary)
        styleSheets = ChuteStyleSheet.decodedStyleSheets(path: URL(fileURLWithPath: compareToFolder).appendingPathComponents(["source", "stylesheets.data"]))
        codeCoverage = ChuteCodeCoverage.findCodeCoverage(testSummaryURL: URL(fileURLWithPath: compareToFolder).appendingPathComponents(["source", "codeCoverage.xccoverage"]))
        codeCoverageSummary = ChuteCodeCoverageSummary(coverages: codeCoverage)
        attachmentRootURL = URL(fileURLWithPath: compareToFolder).appendingPathComponent("attachments")
    }
}
