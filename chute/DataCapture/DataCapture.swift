//
//  DataCapture.swift
//  chute
//
//  Created by David House on 11/15/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

protocol DataCapture {
    var project: String {get}
    var branch: String {get}
    var testExecutionDate: Date {get}
    var testResults: [ChuteTestResult] {get}
    var codeCoverage: [ChuteCodeCoverage] {get}
    var codeCoverageSummary: ChuteCodeCoverageSummary {get}
    var attachments: [ChuteTestAttachment] {get}
    var styleSheets: [ChuteStyleSheet] {get}
    var attachmentRootURL: URL {get}

    init?(using environment: Environment)
    init?(using environment: Environment, from compareToFolder: String?)
}
