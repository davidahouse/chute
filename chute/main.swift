//
//  main.swift
//  chute
//
//  Created by David House on 9/3/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

print("chute: 1.0.0")

let arguments = ChuteCommandLineParameters()

// Required parameters
guard arguments.hasRequiredParameters, let project = arguments.project else {
    arguments.printInstructions()
    exit(1)
}
let fullProjectPath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(project)

// Find derived data folder for this project
//let projectFolder = DerivedData.pathFor(project: "/Users/davidhouse/Projects/davidahouse/EmojiCal/EmojiCal.xcodeproj")
guard let projectFolder = DerivedData.pathFor(project: fullProjectPath.path) else {
    print("Unable to determine project folder, exiting!")
    exit(1)
}
print("DerivedData Folder: \(projectFolder.path)")

// Find the most recent test run
guard let testExecution = DerivedData.recentTestSummary(projectFolder: projectFolder) else {
    print("No recent test execution found for this project")
    exit(1)
}
print("TestSummary Folder: \(testExecution.folderURL)")

// Gather all the test data
let rootAttachmentPath = testExecution.folderURL.deletingLastPathComponent().appendingPathComponent("Attachments")

let testResults = ChuteTestResult.findResults(testSummary: testExecution.summary)
let attachments = ChuteTestAttachment.findAttachments(testSummary: testExecution.summary)
let styleSheets = ChuteStyleSheet.findStyleSheets(testSummary: testExecution.summary, rootPath: rootAttachmentPath)
let codeCoverage = ChuteCodeCoverage.findCodeCoverage()

let chuteTestDetail = ChuteDetail(project: project, testDate: Date(), branch: arguments.branch, pullRequestNumber: arguments.pullRequestNumber, testResults: testResults, codeCoverage: codeCoverage, attachments: attachments, styleSheets: styleSheets)

// Create the output folder
let outputFolder = ChuteOutputFolder()
outputFolder.empty()
outputFolder.saveAttachments(rootPath: rootAttachmentPath, attachments: attachments)
outputFolder.saveSourceFile(from: testExecution.summaryFileURL, to: "TestSummaries.plist")
outputFolder.saveSourceFile(from: ChuteCodeCoverage.codeCoverageURL, to: "report.json")

// Generate chute reports from gathered data
let output = ChuteOutput(into: outputFolder)
output.renderMarkdownOutput(detail: chuteTestDetail)
output.renderHTMLOutput(detail: chuteTestDetail)

// If compareFolder set, load & compare current test with existing data

// If save set, save the gathered data
print("Chute finished.")
