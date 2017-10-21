//
//  CodeCoverage.swift
//  chute
//
//  Created by David House on 9/13/17.
//  Copyright © 2017 David House. All rights reserved.
//
//
//  This set of structs matches the xcov json report output
//  format.

import Foundation

struct CodeCoverageFile: Decodable {
    let name: String
    let coverage: Double
}

struct CodeCoverageTarget: Decodable {
    let name: String
    let coverage: Double
    let files: [CodeCoverageFile]
}

struct CodeCoverage: Decodable {
    let coverage: Double
    let targets: [CodeCoverageTarget]
}

extension CodeCoverage {

    static func fromFile(file: URL) -> CodeCoverage? {
        if let data = try? Data(contentsOf: file) {
            let decoder = JSONDecoder()
            do {
                let coverage = try decoder.decode(CodeCoverage.self, from: data)
                return coverage
            } catch {
                print(error)
            }
        }
        return nil
    }
}
