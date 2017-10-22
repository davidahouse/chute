//
//  ChuteTestAttachment.swift
//  chute
//
//  Created by David House on 10/14/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct ChuteTestAttachment: Encodable {

    let testIdentifier: String
    let attachmentName: String
    let attachmentFileName: String

    init?(testIdentifier: String, attachment: ActivityAttachment) {

        guard let name = attachment.name, let filename = attachment.filename else {
            return nil
        }

        if attachment.uti == "chute.styleSheet" {
            return nil
        }

        self.testIdentifier = testIdentifier
        attachmentName = name
        attachmentFileName = filename
    }
}

extension ChuteTestAttachment {

    static func findAttachments(testSummary: TestSummary) -> [ChuteTestAttachment] {

        var results = [ChuteTestAttachment]()

        for summary in testSummary.testableSummaries {
            for test in summary.tests {
                results += findAttachments(testDetails: test)
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
}
