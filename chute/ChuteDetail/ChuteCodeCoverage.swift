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
    
    init(target: String, files: [ChuteCodeCoverageFile]) {
        if files.count > 0 {
            coveredLines = files.reduce(0) {$0 + $1.coveredLines}
            executableLines = files.reduce(0) {$0 + $1.executableLines}
            lineCoverage = Double(coveredLines) / Double(executableLines)
            targets = [ChuteCodeCoverageTarget(coveredLines: coveredLines, lineCoverage: lineCoverage, name: target, executableLines: executableLines, buildProductPath: "", files: files)]
        } else {
            coveredLines = 0
            lineCoverage = 0.0
            executableLines = 0
            targets = []
        }
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
        print("xccov command: \(xccov)")
        let output = Execute.shell(command: ["-l", "-c", xccov])
        
        guard let outputData = output?.data(using: .utf8) else {
            print("--- Error converting output to data")
            return ChuteCodeCoverage()
        }
        
        let outputString = String(data: outputData, encoding: .utf8)
        print("xccov output: \(outputString ?? "")")
        
        do {
            let decoded = try JSONDecoder().decode(ChuteCodeCoverage.self, from: outputData)
            return decoded
        } catch {
            print("--- Error: \(error)")
            return ChuteCodeCoverage()
        }
    }
    
    static func jacocoCoverageCSV(csvFile: URL) -> ChuteCodeCoverage {
        
        do {
            let fileData = try Data(contentsOf: csvFile)
            guard let fileDataString = String(data: fileData, encoding: .utf8) else {
                return ChuteCodeCoverage()
            }
            
            var files = [ChuteCodeCoverageFile]()
            var target: String = ""
            for line in fileDataString.components(separatedBy: "\n") {
                let parts = line.components(separatedBy: ",")
                
                guard parts.count > 0, parts[0] != "GROUP" else {
                    continue
                }
                
                guard parts.count >= 8, let linesMissed = Int(parts[7]), let linesCovered = Int(parts[8]) else {
                    print("Unable to parse line: \(line)")
                    continue
                }
                
                
                let coverage: Double = {
                    guard linesCovered > 0, linesMissed + linesCovered > 0 else {
                        return 0.0
                    }
                    
                    return Double(Double(linesCovered) / Double(linesCovered + linesMissed))
                }()
                target = parts[0]
                files.append(ChuteCodeCoverageFile(coveredLines: linesCovered, lineCoverage: coverage, path: parts[1], name: parts[2], executableLines: linesCovered + linesMissed))
            }
            return ChuteCodeCoverage(target: target, files: files)
        } catch {
            print("Error opening coverage csv file: \(error)")
            return ChuteCodeCoverage()
        }
    }
}
