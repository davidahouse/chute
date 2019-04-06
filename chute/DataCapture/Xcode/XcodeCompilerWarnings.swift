//
//  XcodeCompilerWarnings.swift
//  chute
//
//  Created by David House on 4/1/19.
//  Copyright © 2019 David House. All rights reserved.
//

import Foundation

class XcodeCompilerWarnings {

    static func find(path: String) -> [String] {

        var warnings = [String]()

        do {
            let logData = try String(contentsOfFile: path)
            for line in logData.components(separatedBy: .newlines) {
                if line.contains("warning:") {
                    let sanitizedLine = line.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\"")
                    warnings.append(sanitizedLine)
                }
            }
        } catch {
            print("Error reading file: \(error)")
        }
        return warnings
    }
}
