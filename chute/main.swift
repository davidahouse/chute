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

let attachments = ChuteDetail.findAttachments(testSummary: testExecution.summary)
let styleSheets = ChuteDetail.findStyleSheets(testSummary: testExecution.summary, rootPath: rootAttachmentPath)

let chuteTestDetail = ChuteDetail(project: project, branch: arguments.branch, pullRequestNumber: arguments.pullRequestNumber, testSummaryFolder: testExecution)

// Generate chute report from gathered data
// TODO: Command line parameters should tell us which output to generate
let outputDetail = ChuteOutputDetail(rootPath: rootAttachmentPath, detail: chuteTestDetail, attachments: attachments, styleSheets: styleSheets)
let output = ChuteOutput()
output.renderMarkdownOutput(detail: outputDetail)
output.renderHTMLOutput(detail: outputDetail)

// If compareFolder set, load & compare current test with existing data

// If save set, save the gathered data
print("Chute finished.")
