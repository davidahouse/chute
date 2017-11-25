//
//  main.swift
//  chute
//
//  Created by David House on 9/3/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

func printOut(_ message: String, with: Printable? = nil) {
    print("---")
    print(message)
    with?.printOut()
    print("---")
    print("")
}

printOut("chute: 1.0.0")

let arguments = CommandLineArguments()
printOut("Arguments:", with: arguments)

// Required parameters
guard arguments.hasRequiredParameters, let project = arguments.project else {
    arguments.printInstructions()
    exit(1)
}

// Environment
let environment = Environment(arguments: arguments)
printOut("Environment:", with: environment)
guard environment.hasValidEnvironment else {
    exit(1)
}

// Capture data using the environment
printOut("Capturing data")
guard let dataCapture = DataCapture(using: environment) else {
    print("Error capturing data")
    exit(1)
}

// Capture saved data from compareTo folder (if specified)
let comparedToDataCapture = DataCapture(using: environment, from: arguments.compareFolder)
var difference: DataCaptureDifference?
if let comparedTo = comparedToDataCapture {
    printOut("Comparing data captures")
    difference = DataCaptureDifference(detail: comparedTo, comparedTo: dataCapture)
}

// Prepare the output folder
printOut("Saving source data to output folder")
let outputFolder = ChuteOutputFolder()
outputFolder.empty()
outputFolder.populate(using: environment, including: dataCapture, and: difference)

// Create reports
printOut("Creating reports")
let output = ChuteOutput(into: outputFolder)
output.createReports(with: dataCapture, and: difference)

// Publish reports
printOut("Publishing reports")
let publisher = Publisher(environment: environment, outputFolder: outputFolder, testExecutionDate: dataCapture.testExecutionDate)
publisher.publish()

// Send notifications
printOut("Sending notifications")
let notifier = Notifier(environment: environment, dataCapture: dataCapture, difference: difference)
notifier.notify()

//
//print("---")
//print("--- Creating chute reports")
//print("---")
//
//// Generate chute reports from gathered data
//let output = ChuteOutput(into: outputFolder)
//output.renderHTMLOutput(detail: chuteTestDetail)
//
//// If compareFolder set, load & compare current test with existing data
//if let compareFolder = arguments.compareFolder {
//
//    print("---")
//    print("--- Loading saved data from compare folder")
//    print("---")
//
//    let beforeAttachmentsURL = URL(fileURLWithPath: compareFolder).appendingPathComponent("attachments")
//    let beforeTestSummaryURL = URL(fileURLWithPath: compareFolder).appendingPathComponents(["source", "TestSummaries.plist"])
//    guard let beforeTestSummary = TestSummary.from(file: beforeTestSummaryURL) else {
//        print("Error comparing results, unabled to find TestSummary.plist in compareFolder of \(compareFolder)")
//        exit(1)
//    }
//
//    print("---")
//    print("--- Calculating difference between test executions")
//    print("---")
//
//    // Perform a diff between the old and new test summaries
//    let beforeTestResults = ChuteTestResult.findResults(testSummary: beforeTestSummary)
//    let beforeAttachments = ChuteTestAttachment.findAttachments(testSummary: beforeTestSummary)
//    let beforeStyleSheets = ChuteStyleSheet.decodedStyleSheets(path: URL(fileURLWithPath: compareFolder).appendingPathComponents(["source", "stylesheets.data"]))
//    let beforeCodeCoverage = ChuteCodeCoverage.findCodeCoverage(testSummaryURL: URL(fileURLWithPath: compareFolder).appendingPathComponents(["source", "codeCoverage.xccoverage"]))
//
//    let beforeTestDetail = ChuteDetail(project: project, testDate: Date(), branch: arguments.branch,
//                                       pullRequestNumber: arguments.pullRequestNumber, testResults: beforeTestResults,
//                                       codeCoverage: beforeCodeCoverage,
//                                       codeCoverageSummary: ChuteCodeCoverageSummary(coverages: beforeCodeCoverage),
//                                       attachments: beforeAttachments, styleSheets: beforeStyleSheets)
//
//    if beforeTestDetail.project != chuteTestDetail.project {
//        print("Unable to compare test results from different projects. \(beforeTestDetail.project) != \(chuteTestDetail.project)")
//    }
//
//    print("---")
//    print("--- Creating difference reports")
//    print("---")
//
//    let compareDetails = ChuteDetailDifference(detail: beforeTestDetail, comparedTo: chuteTestDetail, detailAttachmentURL: beforeAttachmentsURL, comparedToAttachmentURL: rootAttachmentPath)
//    output.renderHTMLDifferenceOutput(difference: compareDetails)
//
//    print("---")
//    print("--- Saving changed views")
//    print("---")
//
//    outputFolder.saveChangedAttachments(rootPath: beforeAttachmentsURL, attachments: compareDetails.viewDifference.changedViews.map { $0.1 })
//
//    print("---")
//    print("--- Generating notifications")
//    print("---")
//
//    if arguments.hasParametersForGithubNotification {
//        let notifier = GithubNotifier()
//        notifier.notify(difference: compareDetails, using: arguments)
//    }
//
//    if arguments.hasParametersForSlackNotification {
//        let notifier = SlackNotifier()
//        notifier.notify(difference: compareDetails, using: arguments)
//    }
//} else {
//
//    print("---")
//    print("--- Generating notifications")
//    print("---")
//
//    if arguments.hasParametersForGithubNotification {
//        let notifier = GithubNotifier()
//        notifier.notify(detail: chuteTestDetail, using: arguments)
//    }
//
//    if arguments.hasParametersForSlackNotification {
//        let notifier = SlackNotifier()
//        notifier.notify(detail: chuteTestDetail, using: arguments)
//    }
//}

// If save set, save the gathered data
printOut("Chute finished.")


