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
        let coverage = coverages.map { $0.coverage }
        averageCoverage = Double(coverage.reduce(0, +))/Double(coverage.count)
        filesAdequatelyCovered = coverages.filter { $0.coverage >= 0.90 }.count
        filesWithNoCoverage = coverages.filter { $0.coverage == 0.0 }.count
    }
}
