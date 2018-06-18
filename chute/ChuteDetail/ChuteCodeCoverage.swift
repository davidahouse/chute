//
//  ChuteCodeCoverage.swift
//  chute
//
//  Created by David House on 10/14/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct ChuteCodeCoverage: Codable {
    let coveredLines: Int
    let lineCoverage: Double
    let executableLines: Int
    let targets: [ChuteCodeCoverageTarget]
    
    init() {
        coveredLines = 0
        lineCoverage = 0.0
        executableLines = 0
        targets = []
    }
    
    func filesCoveredAdequately() -> [ChuteCodeCoverageFile] {
        var files: [ChuteCodeCoverageFile] = []
        for target in targets {
            let foundFiles = target.files.filter { $0.lineCoverage >= 0.90}
            files += foundFiles
        }
        return files
    }
    
    func filesWithNoCoverage() -> [ChuteCodeCoverageFile] {
        var files: [ChuteCodeCoverageFile] = []
        for target in targets {
            let foundFiles = target.files.filter { $0.lineCoverage == 0.0}
            files += foundFiles
        }
        return files
    }
    
    func fileMatching(target: String, name: String) -> ChuteCodeCoverageFile? {
        
        let foundTargets = targets.filter { $0.name == target }
        guard let foundTarget = foundTargets.first else {
            return nil
        }
        
        let foundFiles = foundTarget.files.filter { $0.name == name }
        guard let foundFile = foundFiles.first else {
            return nil
        }
        return foundFile
    }
}

struct ChuteCodeCoverageTarget: Codable {
    let coveredLines: Int
    let lineCoverage: Double
    let name: String
    let executableLines: Int
    let buildProductPath: String
    let files: [ChuteCodeCoverageFile]
}

struct ChuteCodeCoverageFile: Codable {
    let coveredLines: Int
    let lineCoverage: Double
    let path: String
    let name: String
    let executableLines: Int
}


extension ChuteCodeCoverage {
    
    static func codeCoverageURL(testSummaryURL: URL) -> URL {
        let path = testSummaryURL.path.replacingOccurrences(of: "_TestSummaries.plist", with: ".xccovreport")
        return URL(fileURLWithPath: path)
    }

    static func findCodeCoverage(testSummaryURL: URL) -> ChuteCodeCoverage {

        let path = ChuteCodeCoverage.codeCoverageURL(testSummaryURL: testSummaryURL)
        
        // Execute xccov to get a friendly output
        let xccov: String = "xcrun xccov view --json \(path.path)"
        let output = Execute.shell(command: ["-l", "-c", xccov])
        
        guard let outputData = output?.data(using: .utf8) else {
            print("--- Error converting output to data")
            return ChuteCodeCoverage()
        }
        
        do {
            let decoded = try JSONDecoder().decode(ChuteCodeCoverage.self, from: outputData)
            return decoded
        } catch {
            print("--- Error: \(error)")
            return ChuteCodeCoverage()
        }
    }
}
