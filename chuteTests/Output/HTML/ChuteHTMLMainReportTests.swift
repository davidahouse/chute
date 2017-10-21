//
//  ChuteHTMLMainReportTests.swift
//  chuteTests
//
//  Created by David House on 10/20/17.
//  Copyright © 2017 David House. All rights reserved.
//

import XCTest
@testable import chute

class ChuteHTMLMainReportTests: XCTestCase {

    func testMainReportRendersSomething() {

        let testSummary = TestSummary(formatVersion: "", testableSummaries: [])

        let testSummaryFolder = TestSummaryFolder(createDate: Date(), folderURL: URL(string: "/")!, summary: testSummary)

        let chuteDetail = ChuteDetail(project: "aProject", branch: "aBranch", pullRequestNumber: "aPullRequestNumber", testSummaryFolder: testSummaryFolder)

        let detail = ChuteOutputDetail(rootPath: URL(string: "/")!, detail: chuteDetail, attachments: [], styleSheets: [])

        let report = ChuteHTMLMainReport()
        XCTAssertTrue(report.render(detail: detail).count > 0)
    }
}
