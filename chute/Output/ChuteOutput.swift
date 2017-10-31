//
//  ChuteOutput.swift
//  chute
//
//  Created by David House on 10/20/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

protocol ChuteOutputRenderable {
    func render(detail: ChuteDetail) -> String
}

protocol ChuteOutputDifferenceRenderable {
    func render(difference: ChuteDetailDifference) -> String
}

class ChuteOutput {

    let outputFolder: ChuteOutputFolder

    init(into outputFolder: ChuteOutputFolder) {
        self.outputFolder = outputFolder
    }

    func renderHTMLOutput(detail: ChuteDetail) {

        let reports: [String: ChuteOutputRenderable] = [
            "chute.html": ChuteHTMLMainReport(),
            "test_details.html": ChuteHTMLTestDetailReport(),
            "code_coverage.html": ChuteHTMLCodeCoverageReport(),
            "style_sheet.html": ChuteHTMLStyleSheetReport()
        ]
        render(reports, with: detail)
    }

    func renderMarkdownOutput(detail: ChuteDetail) {

        let reports: [String: ChuteOutputRenderable] = [
            "chute.md": ChuteMarkdownMainReport(),
            "test_details.md": ChuteMarkdownTestDetailReport(),
            "code_coverage.md": ChuteMarkdownCodeCoverageReport(),
            "style_sheet.md": ChuteMarkdownStyleSheetReport()
        ]
        render(reports, with: detail)
    }

    func renderHTMLDifferenceOutput(difference: ChuteDetailDifference) {

        let reports: [String: ChuteOutputDifferenceRenderable] = [
            "chute_difference.html": ChuteHTMLDifferenceMainReport(),
            "test_details_difference.html": ChuteHTMLDifferenceTestDetailReport(),
            "code_coverage_difference.html": ChuteHTMLCodeCoverageDifferenceReport(),
            "style_sheet_difference.html": ChuteHTMLStyleSheetDifferenceReport()
        ]
        render(reports, with: difference)
    }

    private func render(_ reports: [String: ChuteOutputRenderable], with detail: ChuteDetail) {

        reports.forEach {
            let output = $0.value.render(detail: detail)
            outputFolder.saveOutputFile(fileName: $0.key, contents: output)
        }
    }

    private func render(_ reports: [String: ChuteOutputDifferenceRenderable], with difference: ChuteDetailDifference) {

        reports.forEach {
            let output = $0.value.render(difference: difference)
            outputFolder.saveOutputFile(fileName: $0.key, contents: output)
        }
    }
}
