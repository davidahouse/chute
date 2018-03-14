//
//  ChuteCodeCoverageSummary.swift
//  chute
//
//  Created by David House on 10/29/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct ChuteCodeCoverageSummary: Encodable {
    let averageCoverage: Double
    let filesAdequatelyCovered: Int
    let filesWithNoCoverage: Int

    init(coverages: [ChuteCodeCoverage]) {
        let coverageList = coverages.map { $0.coverage }
        let coverage = coverageList.reduce(0.0, +)
        if coverage > 0 && coverageList.count > 0 {
            averageCoverage = coverage/Double(coverageList.count)
        } else {
            averageCoverage = 0.0
        }
        filesAdequatelyCovered = coverages.filter { $0.coverage >= 0.90 }.count
        filesWithNoCoverage = coverages.filter { $0.coverage == 0.0 }.count
    }
}
