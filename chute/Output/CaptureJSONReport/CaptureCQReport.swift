//
//  CaptureReport.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct CaptureCQReport: ChuteOutputRenderable {

    enum Constants {
        static let Template = """
        {
            "warnings": {{warnings}},
            "lintFindings": {{lintFindings}}
        }
        """

        static let WarningTemplate = """
        {
            "{{warning}}"
        }
        """
    }

    func render(dataCapture: DataCapture) -> String {

        var warnings = ""
        do {
            let encoder = JSONEncoder()
            let output = try encoder.encode(dataCapture.compilerWarnings)
            warnings = String(data: output, encoding: .utf8) ?? ""
        } catch {
            print("error encoding JSON: \(error)")
        }

        var lintFindings = ""
        do {
            let encoder = JSONEncoder()
            let output = try encoder.encode(dataCapture.lintWarnings)
            lintFindings = String(data: output, encoding: .utf8) ?? ""
        } catch {
            print("error encoding JSON: \(error)")
        }

        let parameters: [String: CustomStringConvertible] = [
            "warnings": warnings,
            "lintFindings": lintFindings
        ]
        return Constants.Template.render(parameters: parameters)
    }
}
