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

    init(coverages: ChuteCodeCoverage) {
        averageCoverage = coverages.lineCoverage
        filesAdequatelyCovered = coverages.filesCoveredAdequately().count
        filesWithNoCoverage = coverages.filesWithNoCoverage().count
    }
}
