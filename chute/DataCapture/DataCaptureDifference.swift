//
//  DataCaptureDifference.swift
//  chute
//
//  Created by David House on 11/15/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct DataCaptureDifference {
    
//    let project: String
    let detail: DataCapture
    let comparedTo: DataCapture
//    let originBranch: String?
//    let comparedBranch: String?
    
    let testResultDifference: ChuteTestResultDifference
    let codeCoverageDifference: ChuteCodeCoverageDifference
    let styleSheetDifference: ChuteStyleSheetDifference
    let viewDifference: ViewDifference
    
    init(detail: DataCapture, comparedTo: DataCapture) {
        
//        project = detail.project
        self.detail = detail
        self.comparedTo = comparedTo
//        originBranch = detail.branch
//        comparedBranch = comparedTo.branch
        
        testResultDifference = ChuteTestResultDifference(detail: detail, comparedTo: comparedTo, detailAttachmentURL: detail.attachmentRootURL, comparedToAttachmentURL: comparedTo.attachmentRootURL)
        codeCoverageDifference = ChuteCodeCoverageDifference(detail: detail, comparedTo: comparedTo)
        styleSheetDifference = ChuteStyleSheetDifference(detail: detail, comparedTo: comparedTo)
        viewDifference = ViewDifference(detail: detail, comparedTo: comparedTo, detailAttachmentURL: detail.attachmentRootURL, comparedToAttachmentURL: comparedTo.attachmentRootURL)
    }
}
