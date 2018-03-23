//
//  AndroidDataCapture.swift
//  chute
//
//  Created by David House on 2/16/18.
//  Copyright © 2018 David House. All rights reserved.
//

import Foundation

struct AndroidDataCapture : DataCapture {
    
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
        
        project = environment.arguments.project ?? ""
        branch = environment.arguments.branch ?? ""
//        testExecutionDate = testSummaryFolder.createDate
        testExecutionDate = Date()
        
        var foundTestResults = [ChuteTestResult]()
        if let buildFolder = environment.buildFolder {
            let testResultsFolder = buildFolder.rootURL.appendingPathComponents(["test-results", "testDebugUnitTest"])
            if let paths = try? FileManager.default.contentsOfDirectory(at: testResultsFolder, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants) {
                
                for path in paths {
                    
                    if path.lastPathComponent.hasSuffix(".xml") {
                        print("test: \(path)")
                        
                        let junitDetails = JUnitTestDetails(path: path)
                        for testSuite in junitDetails.testSuites {
                        
                            for testCase in testSuite.testCases {
                                let result = ChuteTestResult(identifier: testSuite.name + "/" + testCase.name, status: testCase.status)
                                foundTestResults.append(result)
                            }
                        }
                    }
                }
            }
        }
        testResults = foundTestResults
        
        codeCoverage = []
        codeCoverageSummary = ChuteCodeCoverageSummary(coverages: [])
        attachments = []
        styleSheets  = []
        let userPath = NSHomeDirectory()
        let userPathURL = URL(fileURLWithPath: userPath)
        attachmentRootURL = userPathURL
    }
    
    init?(using environment: Environment, from compareToFolder: String?) {
        
        project = environment.arguments.project ?? ""
        branch = environment.arguments.branch ?? ""
        //        testExecutionDate = testSummaryFolder.createDate
        testExecutionDate = Date()
        testResults = []
        codeCoverage = []
        codeCoverageSummary = ChuteCodeCoverageSummary(coverages: [])
        attachments = []
        styleSheets  = []
        let userPath = NSHomeDirectory()
        let userPathURL = URL(fileURLWithPath: userPath)
        attachmentRootURL = userPathURL
    }
}
