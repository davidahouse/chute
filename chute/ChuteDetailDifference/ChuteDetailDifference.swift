//
//  ChuteDetailDifference.swift
//  chute
//
//  Created by David House on 10/23/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct ChuteDetailDifference {

    let project: String
    let detail: ChuteDetail
    let comparedTo: ChuteDetail
    let originBranch: String?
    let comparedBranch: String?

    let testResultDifference: ChuteTestResultDifference
    let codeCoverageDifference: ChuteCodeCoverageDifference
    let styleSheetDifference: ChuteStyleSheetDifference

    init(detail: ChuteDetail, comparedTo: ChuteDetail, detailAttachmentURL: URL, comparedToAttachmentURL: URL) {

        project = detail.project
        self.detail = detail
        self.comparedTo = comparedTo
        originBranch = detail.branch
        comparedBranch = comparedTo.branch

        testResultDifference = ChuteTestResultDifference(detail: detail, comparedTo: comparedTo, detailAttachmentURL: detailAttachmentURL, comparedToAttachmentURL: comparedToAttachmentURL)
        codeCoverageDifference = ChuteCodeCoverageDifference(detail: detail, comparedTo: comparedTo)
        styleSheetDifference = ChuteStyleSheetDifference(detail: detail, comparedTo: comparedTo)
    }
}
