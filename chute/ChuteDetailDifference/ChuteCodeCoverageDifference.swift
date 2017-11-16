//
//  ChuteCodeCoverageDifference.swift
//  chute
//
//  Created by David House on 10/29/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct ChuteCodeCoverageDifference {

    let originSummary: ChuteCodeCoverageSummary
    let comparedToSummary: ChuteCodeCoverageSummary
    let codeCoverageChanges: [(ChuteCodeCoverage, Double)]

    init(detail: DataCapture, comparedTo: DataCapture) {

        originSummary = detail.codeCoverageSummary
        comparedToSummary = comparedTo.codeCoverageSummary

        var changes = [(ChuteCodeCoverage, Double)]()
        for codeCoverage in comparedTo.codeCoverage {

            let found = detail.codeCoverage.filter { $0.target == codeCoverage.target && $0.file == codeCoverage.file }
            if found.count > 0, let first = found.first {
                if first.coverage != codeCoverage.coverage {
                    changes.append((codeCoverage, codeCoverage.coverage - first.coverage))
                }
            } else {
                changes.append((codeCoverage, codeCoverage.coverage))
            }
        }
        codeCoverageChanges = changes
    }
}
