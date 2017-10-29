//
//  ChuteTestResultDifference.swift
//  chute
//
//  Created by David House on 10/29/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct ChuteTestResultDifference {

    let newTestResults: [ChuteTestResult]
    let changedTestResults: [(ChuteTestResult, ChuteTestResult)]
    let removedTestResults: [ChuteTestResult]
    let attachments: [ChuteTestAttachment]

    init(detail: ChuteDetail, comparedTo: ChuteDetail, detailAttachmentURL: URL, comparedToAttachmentURL: URL) {

        var newResults = [ChuteTestResult]()
        var changedResults = [(ChuteTestResult, ChuteTestResult)]()
        var removedResults = [ChuteTestResult]()
        var foundAttachments = [ChuteTestAttachment]()

        for test in comparedTo.testResults {

            let foundTests = detail.testResults.filter { $0.testIdentifier == test.testIdentifier }
            if let foundTest: ChuteTestResult = foundTests.first {
                if foundTest.testStatus != test.testStatus {
                    changedResults.append((foundTest, test))
                    foundAttachments += comparedTo.attachments.filter { $0.testIdentifier == test.testIdentifier }
                } else if let differentAttachments = ChuteTestResultDifference.differentAttachments(testIdentifier: test.testIdentifier, detailAttachments: detail.attachments, comparedToAttachments: comparedTo.attachments, detailAttachmentURL: detailAttachmentURL, comparedToAttachmentURL: comparedToAttachmentURL) {
                    changedResults.append((foundTest, test))
                    foundAttachments += differentAttachments
                }
            } else {
                newResults.append(test)
                foundAttachments += comparedTo.attachments.filter { $0.testIdentifier == test.testIdentifier }
            }
        }

        for test in detail.testResults {

            let foundTests = comparedTo.testResults.filter { $0.testIdentifier == test.testIdentifier }
            if foundTests.isEmpty {
                removedResults.append(test)
            }
        }

        newTestResults = newResults
        changedTestResults = changedResults
        removedTestResults = removedResults
        attachments = foundAttachments
    }

    static func differentAttachments(testIdentifier: String, detailAttachments: [ChuteTestAttachment], comparedToAttachments: [ChuteTestAttachment], detailAttachmentURL: URL, comparedToAttachmentURL: URL) -> [ChuteTestAttachment]? {

        var different = [ChuteTestAttachment]()
        let comparing = comparedToAttachments.filter { $0.testIdentifier == testIdentifier }
        for attachment in comparing {

            let foundAttachments = detailAttachments.filter { $0.testIdentifier == testIdentifier && $0.attachmentName == attachment.attachmentName }
            if foundAttachments.isEmpty {
                different.append(attachment)
            } else {
                // Need the data for the two different attachments here...
                if let foundAttachment = foundAttachments.first {
                    let originFileURL = detailAttachmentURL.appendingPathComponent(foundAttachment.attachmentFileName)
                    let comparedToFileURL = comparedToAttachmentURL.appendingPathComponent(attachment.attachmentFileName)

                    if let originData = try? Data(contentsOf: originFileURL), let comparedToData = try? Data(contentsOf: comparedToFileURL) {

                        if originData != comparedToData {
                            different.append(attachment)
                        }
                    }
                }
            }
        }
        return different.isEmpty ? nil : different
    }
}
