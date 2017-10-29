//
//  main.swift
//  chute
//
//  Created by David House on 9/3/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

print("---")
print("--- chute: 1.0.0")
print("---")

let arguments = ChuteCommandLineParameters()

// Required parameters
guard arguments.hasRequiredParameters, let project = arguments.project else {
    arguments.printInstructions()
    exit(1)
}
let fullProjectPath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(project)

print("---")
print("--- Searching for DerivedData folder for this project")
print("---")

// Find derived data folder for this project
//let projectFolder = DerivedData.pathFor(project: "/Users/davidhouse/Projects/davidahouse/EmojiCal/EmojiCal.xcodeproj")
guard let projectFolder = DerivedData.pathFor(project: fullProjectPath.path) else {
    print("Unable to determine project folder, exiting!")
    exit(1)
}
print("--- DerivedData Folder: \(projectFolder.path)")

print("---")
print("--- Searching for most recent test execution")
print("---")

// Find the most recent test run
guard let testExecution = DerivedData.recentTestSummary(projectFolder: projectFolder) else {
    print("No recent test execution found for this project")
    exit(1)
}
print("--- TestSummary Folder: \(testExecution.folderURL)")

print("---")
print("--- Gathering test data")
print("---")

// Gather all the test data
let rootAttachmentPath = testExecution.folderURL.deletingLastPathComponent().appendingPathComponent("Attachments")

let testResults = ChuteTestResult.findResults(testSummary: testExecution.summary)
let attachments = ChuteTestAttachment.findAttachments(testSummary: testExecution.summary)
let styleSheets = ChuteStyleSheet.findStyleSheets(testSummary: testExecution.summary, rootPath: rootAttachmentPath)
let codeCoverage = ChuteCodeCoverage.findCodeCoverage()

let chuteTestDetail = ChuteDetail(project: project, testDate: Date(), branch: arguments.branch, pullRequestNumber: arguments.pullRequestNumber, testResults: testResults, codeCoverage: codeCoverage, attachments: attachments, styleSheets: styleSheets)

print("---")
print("--- Saving source data to output folder")
print("---")

// Create the output folder
let outputFolder = ChuteOutputFolder()
outputFolder.empty()
outputFolder.saveAttachments(rootPath: rootAttachmentPath, attachments: attachments)
outputFolder.saveSourceFile(from: testExecution.summaryFileURL, to: "TestSummaries.plist")
outputFolder.saveSourceFile(from: ChuteCodeCoverage.codeCoverageURL, to: "report.json")
if let styleSheetData = ChuteStyleSheet.encodedStyleSheets(from: styleSheets) {
    outputFolder.saveSourceFile(fileName: "stylesheets.data", data: styleSheetData)
}

print("---")
print("--- Creating chute reports")
print("---")

// Generate chute reports from gathered data
let output = ChuteOutput(into: outputFolder)
output.renderMarkdownOutput(detail: chuteTestDetail)
output.renderHTMLOutput(detail: chuteTestDetail)

// If compareFolder set, load & compare current test with existing data
if let compareFolder = arguments.compareFolder {

    print("---")
    print("--- Loading saved data from compare folder")
    print("---")

    let beforeAttachmentsURL = URL(fileURLWithPath: compareFolder).appendingPathComponent("attachments")
    let beforeTestSummaryURL = URL(fileURLWithPath: compareFolder).appendingPathComponents(["source", "TestSummaries.plist"])
    guard let beforeTestSummary = TestSummary.from(file: beforeTestSummaryURL) else {
        print("Error comparing results, unabled to find TestSummary.plist in compareFolder of \(compareFolder)")
        exit(1)
    }

    print("---")
    print("--- Calculating difference between test executions")
    print("---")

    // Perform a diff between the old and new test summaries
    let beforeTestResults = ChuteTestResult.findResults(testSummary: beforeTestSummary)
    let beforeAttachments = ChuteTestAttachment.findAttachments(testSummary: beforeTestSummary)
    let beforeStyleSheets = ChuteStyleSheet.decodedStyleSheets(path: URL(fileURLWithPath: compareFolder).appendingPathComponents(["source", "stylesheets.data"]))
    let beforeCodeCoverage = ChuteCodeCoverage.findCodeCoverage()

    let beforeTestDetail = ChuteDetail(project: project, testDate: Date(), branch: arguments.branch, pullRequestNumber: arguments.pullRequestNumber, testResults: beforeTestResults, codeCoverage: beforeCodeCoverage, attachments: beforeAttachments, styleSheets: beforeStyleSheets)

    if beforeTestDetail.project != chuteTestDetail.project {
        print("Unable to compare test results from different projects. \(beforeTestDetail.project) != \(chuteTestDetail.project)")
    }

    print("---")
    print("--- Creating difference reports")
    print("---")

    let compareDetails = ChuteDetailDifference(detail: beforeTestDetail, comparedTo: chuteTestDetail, detailAttachmentURL: beforeAttachmentsURL, comparedToAttachmentURL: rootAttachmentPath)
    output.renderHTMLDifferenceOutput(difference: compareDetails)
}

// If save set, save the gathered data
print("--- Chute finished.")
