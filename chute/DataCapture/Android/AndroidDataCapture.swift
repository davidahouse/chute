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
    let codeCoverage: ChuteCodeCoverage
    let codeCoverageSummary: ChuteCodeCoverageSummary
    let attachments: [ChuteTestAttachment]
    let styleSheets: [ChuteStyleSheet]
    let attachmentRootURL: URL
    let compilerWarnings: [String]
    let lintWarnings: [ChuteLintWarning]

    init?(using environment: Environment) {
        
        project = environment.arguments.project ?? ""
        branch = environment.arguments.branch ?? ""
//        testExecutionDate = testSummaryFolder.createDate
        testExecutionDate = Date()
        
        var foundTestResults = [ChuteTestResult]()
        if let buildFolder = environment.buildFolder {
            
            if environment.hasVerboseLogging {
                buildFolder.rootURL.printOutFileTree()
            }
            let testResultsFolder = buildFolder.rootURL.appendingPathComponents(["test-results", "testDebugUnitTest"])
            if let paths = try? FileManager.default.contentsOfDirectory(at: testResultsFolder, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants) {
                
                for path in paths {
                    
                    if path.lastPathComponent.hasSuffix(".xml") {
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

            let codeCoverageOutput = buildFolder.rootURL.appendingPathComponents(["reports", "jacocoTestReport.csv"])
            codeCoverage = ChuteCodeCoverage.jacocoCoverageCSV(csvFile: codeCoverageOutput)
        } else {
            codeCoverage = ChuteCodeCoverage()
        }
        testResults = foundTestResults
        
        codeCoverageSummary = ChuteCodeCoverageSummary(coverages: codeCoverage)
        attachments = []
        styleSheets  = []
        let userPath = NSHomeDirectory()
        let userPathURL = URL(fileURLWithPath: userPath)
        attachmentRootURL = userPathURL
        // TODO: get these for Android
        compilerWarnings = []
        lintWarnings = []
    }
    
    init?(using environment: Environment, from compareToFolder: String?) {
        
        guard let compareToFolder = compareToFolder else {
            return nil
        }
        
        // TODO: Actually load data from saved source data.
        
        project = environment.arguments.project ?? ""
        branch = environment.arguments.branch ?? ""
        //        testExecutionDate = testSummaryFolder.createDate
        testExecutionDate = Date()
        testResults = []
        codeCoverage = ChuteCodeCoverage()
        codeCoverageSummary = ChuteCodeCoverageSummary(coverages: ChuteCodeCoverage())
        attachments = []
        styleSheets  = []
        let userPath = NSHomeDirectory()
        let userPathURL = URL(fileURLWithPath: userPath)
        attachmentRootURL = userPathURL
        compilerWarnings = []
        lintWarnings = []
    }
}
