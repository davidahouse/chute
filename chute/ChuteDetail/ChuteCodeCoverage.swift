//
//  ChuteCodeCoverage.swift
//  chute
//
//  Created by David House on 10/14/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct ChuteCodeCoverage: Encodable {
    let target: String
    let file: String
    let coverage: Double
}

extension ChuteCodeCoverage {

    static var codeCoverageURL: URL {
        return URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponents(["xcov_report", "report.json"])
    }

    static func findCodeCoverage(path: URL) -> [ChuteCodeCoverage] {
        // TODO: We should run xcov ourselves here instead of assuming
        // it was run for us.
        // xcov --workspace nbc-portal-tv.xcworkspace --scheme nbc-dev-portal-tv --json_report
        var codeCoverage = [ChuteCodeCoverage]()
        if let coverage = CodeCoverage.fromFile(file: path) {

            for target in coverage.targets {
                for file in target.files {
                    codeCoverage.append(ChuteCodeCoverage(target: target.name, file: file.name, coverage: file.coverage))
                }
            }
        }
        return codeCoverage
    }
}
