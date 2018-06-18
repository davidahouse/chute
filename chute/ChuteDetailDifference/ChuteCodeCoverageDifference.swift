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
    let codeCoverageChanges: [(String, ChuteCodeCoverageFile, Double)]

    init(detail: DataCapture, comparedTo: DataCapture) {

        originSummary = detail.codeCoverageSummary
        comparedToSummary = comparedTo.codeCoverageSummary

        var changes = [(String, ChuteCodeCoverageFile, Double)]()
        for target in comparedTo.codeCoverage.targets {
            
            for file in target.files {
                
                if let foundFile = detail.codeCoverage.fileMatching(target: target.name, name: file.name) {
                    if foundFile.lineCoverage != file.lineCoverage {
                        changes.append((target.name, file, file.lineCoverage - foundFile.lineCoverage))
                    }
                } else {
                    changes.append((target.name, file, file.lineCoverage))
                }
            }
        }
        codeCoverageChanges = changes
    }
}
