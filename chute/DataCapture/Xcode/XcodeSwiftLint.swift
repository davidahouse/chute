//
//  XcodeCompilerWarnings.swift
//  chute
//
//  Created by David House on 4/1/19.
//  Copyright © 2019 David House. All rights reserved.
//

import Foundation

class XcodeSwiftLint {

    struct SwiftLintWarning: Codable {
        let character: Int?
        let file: String
        let line: Int
        let reason: String
        let rule_id: String
        let severity: String
        let type: String
    }

    static func find(path: String) -> [ChuteLintWarning] {

        var warnings = [ChuteLintWarning]()

        do {
            let rawData = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            let lintWarnings = try decoder.decode([SwiftLintWarning].self, from: rawData)

            for warning in lintWarnings {
                let filePath = URL(fileURLWithPath: warning.file)

                warnings.append(ChuteLintWarning(fileName: filePath.lastPathComponent, line: warning.line, character: warning.character, description: warning.reason,  rule: warning.rule_id, severity: warning.severity))
            }

        } catch {
            print("Error reading swiftlint file: \(error)")
        }
        return warnings
    }
}
