//
//  XcodeCompilerWarnings.swift
//  chute
//
//  Created by David House on 4/1/19.
//  Copyright © 2019 David House. All rights reserved.
//

import Foundation

class XcodeInfer {

    struct InferWarning: Codable {
        let kind: String
        let bug_type: String
        let qualifier: String
        let severity: String
        let line: Int?
        let column: Int?
        let file: String
    }

    static func find(path: String) -> [ChuteLintWarning] {

        var warnings = [ChuteLintWarning]()

        do {
            let rawData = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            let lintWarnings = try decoder.decode([InferWarning].self, from: rawData)

            for warning in lintWarnings {
                let filePath = URL(fileURLWithPath: warning.file)

                warnings.append(ChuteLintWarning(fileName: filePath.lastPathComponent, line: warning.line, character: warning.column, description: warning.qualifier, rule: warning.bug_type, severity: warning.severity))
            }

        } catch {
            print("Error reading swiftlint file: \(error)")
        }
        return warnings
    }
}
