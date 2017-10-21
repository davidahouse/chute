//
//  ChuteTestDetail.swift
//  chute
//
//  Created by David House on 9/4/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct ChuteDetail: Encodable {

    let project: String
    let testDate: Date
    let branch: String?
    let pullRequestNumber: String?
    let testResults: [ChuteTestResult]
    let codeCoverage: [ChuteCodeCoverage]

    init(project: String, branch: String?, pullRequestNumber: String?, testSummaryFolder: TestSummaryFolder) {
        self.project = project
        self.testDate = Date()
        self.branch = branch
        self.pullRequestNumber = pullRequestNumber
        testResults = ChuteDetail.findResults(testSummary: testSummaryFolder.summary)

        // TODO: We should run xcov ourselves here instead of assuming
        // it was run for us.
        // xcov --workspace nbc-portal-tv.xcworkspace --scheme nbc-dev-portal-tv --json_report
        var codeCoverage = [ChuteCodeCoverage]()
        let codeCoveragePath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponents(["xcov_report", "report.json"])
        if let coverage = CodeCoverage.fromFile(file: codeCoveragePath) {

            for target in coverage.targets {
                for file in target.files {
                    codeCoverage.append(ChuteCodeCoverage(target: target.name, file: file.name, coverage: file.coverage))
                }
            }
        }
        self.codeCoverage = codeCoverage
    }
}

extension ChuteDetail {

    static func findResults(testSummary: TestSummary) -> [ChuteTestResult] {

        var results = [ChuteTestResult]()

        for summary in testSummary.testableSummaries {
            for test in summary.tests {
                results += findTestableSummaries(testDetails: test)
            }
        }

        return results
    }

    static func findAttachments(testSummary: TestSummary) -> [ChuteTestAttachment] {

        var results = [ChuteTestAttachment]()

        for summary in testSummary.testableSummaries {
            for test in summary.tests {
                results += findAttachments(testDetails: test)
            }
        }

        return results
    }

    static func findStyleSheets(testSummary: TestSummary, rootPath: URL) -> [ChuteStyleSheet] {

        var results = [ChuteStyleSheet]()
        for summary in testSummary.testableSummaries {
            for test in summary.tests {
                results += findStyleSheets(testDetails: test, rootPath: rootPath)
            }
        }
        return results
    }

    private static func findTestableSummaries(testDetails: TestDetails) -> [ChuteTestResult] {

        var results = [ChuteTestResult]()

        if let result = ChuteTestResult(detail: testDetails) {
            results += [result]
        }

        if let subtests = testDetails.subtests {

            for subtest in subtests {
                results += findTestableSummaries(testDetails: subtest)
            }
        }

        return results
    }

    private static func findAttachments(testDetails: TestDetails) -> [ChuteTestAttachment] {

        var results = [ChuteTestAttachment]()

        if let activities = testDetails.activitySummaries {
            for activity in activities {
                if let attachments = activity.attachments {
                    for attachment in attachments {

                        if let chuteAttachment = ChuteTestAttachment(testIdentifier: testDetails.testIdentifier ?? "", attachment: attachment) {
                            results.append(chuteAttachment)
                        }
                    }
                }
            }
        }

        if let subtests = testDetails.subtests {

            for subtest in subtests {
                results += findAttachments(testDetails: subtest)
            }
        }
        return results
    }

    private static func findStyleSheets(testDetails: TestDetails, rootPath: URL) -> [ChuteStyleSheet] {

        var results = [ChuteStyleSheet]()

        if let activities = testDetails.activitySummaries {
            for activity in activities {
                if let attachments = activity.attachments {
                    for attachment in attachments.filter({ $0.uti == "chute.styleSheet" }) {

                        let dataPath = rootPath.appendingPathComponent(attachment.filename!)
                        do {
                            let data = try Data(contentsOf: dataPath)

                            let decoder = JSONDecoder()
                            do {
                                let styleSheet = try decoder.decode(Array<ChuteStyleSheet>.self, from: data)
                                results += styleSheet
                            } catch {
                                print(error)
                            }
                        } catch {
                            print("error loading attachment: \(error)")
                        }
                    }
                }
            }
        }

        if let subtests = testDetails.subtests {

            for subtest in subtests {
                results += findStyleSheets(testDetails: subtest, rootPath: rootPath)
            }
        }
        return results
    }
}
