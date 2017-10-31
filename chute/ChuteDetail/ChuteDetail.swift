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
    let codeCoverageSummary: ChuteCodeCoverageSummary
    let attachments: [ChuteTestAttachment]
    let styleSheets: [ChuteStyleSheet]
}
