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
    let functions: [ChuteCodeCoverageFunction]
}

struct ChuteCodeCoverageFunction: Encodable {
    let name: String
    let coverage: Double
}

@objc(IDESchemeActionCodeCoverage) class IDESchemeActionCodeCoverage: NSObject, NSCoding {
    
    let codeCoverageTargets: [IDESchemeActionCodeCoverageTarget]
    
    required init?(coder aDecoder: NSCoder) {
        guard let targets = aDecoder.decodeObject(forKey: "buildableCoverageObjects") as? [IDESchemeActionCodeCoverageTarget] else {
            return nil
        }
        codeCoverageTargets = targets
    }
    
    func encode(with aCoder: NSCoder) {
    }
}

@objc(IDESchemeActionCodeCoverageTarget) class IDESchemeActionCodeCoverageTarget: NSObject, NSCoding {
    
    let productPath: NSString
    let buildableIdentifier: NSString
    let sourceFiles: [IDESchemeActionCodeCoverageFile]
    let lineCoverage: NSNumber
    let uniqueIdentifier: NSString
    let name: NSString
    
    required init?(coder aDecoder: NSCoder) {
        
        guard let path = aDecoder.decodeObject(forKey: "productPath") as? NSString,
                let identifier = aDecoder.decodeObject(forKey: "buildableIdentifier") as? NSString,
            let files = aDecoder.decodeObject(forKey: "sourceFiles") as? [IDESchemeActionCodeCoverageFile],
            let coverage = aDecoder.decodeObject(forKey: "lineCoverage") as? NSNumber,
            let uniqueIdentifier = aDecoder.decodeObject(forKey: "uniqueIdentifier") as? NSString,
            let name = aDecoder.decodeObject(forKey: "name") as? NSString else {
                return nil
        }
        
        productPath = path
        buildableIdentifier = identifier
        sourceFiles = files
        lineCoverage = coverage
        self.uniqueIdentifier = uniqueIdentifier
        self.name = name
    }
    
    func encode(with aCoder: NSCoder) {
    }
}

@objc(IDESchemeActionCodeCoverageFile) class IDESchemeActionCodeCoverageFile: NSObject, NSCoding {
    
    let lines: Any?
    let functions: [IDESchemeActionCodeCoverageFunction]
    let documentLocation: NSString
    let lineCoverage: NSNumber
    let uniqueIdentifier: NSString
    let name: NSString

    required init?(coder aDecoder: NSCoder) {
    
        guard let location = aDecoder.decodeObject(forKey: "documentLocation") as? NSString,
            let functions = aDecoder.decodeObject(forKey: "functions") as? [IDESchemeActionCodeCoverageFunction],
            let lines = aDecoder.decodeObject(forKey: "lines"),
            let coverage = aDecoder.decodeObject(forKey: "lineCoverage") as? NSNumber,
            let uniqueIdentifier = aDecoder.decodeObject(forKey: "uniqueIdentifier") as? NSString,
            let name = aDecoder.decodeObject(forKey: "name") as? NSString else {
                return nil
        }
        
        self.lines = lines
        self.functions = functions
        documentLocation = location
        lineCoverage = coverage
        self.uniqueIdentifier = uniqueIdentifier
        self.name = name
    }
    
    func encode(with aCoder: NSCoder) {
    }
}

@objc(IDESchemeActionCodeCoverageFunction) class IDESchemeActionCodeCoverageFunction: NSObject, NSCoding {
    
    let symbolKind: NSString
    let lineNumber: Int32
    let executionCount: Int32
    let lineCoverage: NSNumber
    let uniqueIdentifier: NSString
    let name: NSString
    
    required init?(coder aDecoder: NSCoder) {
        
        guard let symbolKind = aDecoder.decodeObject(forKey: "symbolKindIdentifier") as? NSString,
            let coverage = aDecoder.decodeObject(forKey: "lineCoverage") as? NSNumber,
            let uniqueIdentifier = aDecoder.decodeObject(forKey: "uniqueIdentifier") as? NSString,
            let name = aDecoder.decodeObject(forKey: "name") as? NSString else {
            return nil
        }

        self.symbolKind = symbolKind
        lineNumber = aDecoder.decodeInt32(forKey: "lineNumber")
        executionCount = aDecoder.decodeInt32(forKey: "executionCount")
        self.lineCoverage = coverage
        self.uniqueIdentifier = uniqueIdentifier
        self.name = name
    }
    
    func encode(with aCoder: NSCoder) { }
}

@objc(DVTSourceFileLineCoverageData) class DVTSourceFileLineCoverageData: NSObject, NSCoding {
    required init?(coder aDecoder: NSCoder) {
    }
    
    func encode(with aCoder: NSCoder) { }
}

extension ChuteCodeCoverage {
    
    static func codeCoverageURL(testSummaryURL: URL) -> URL {
        let path = testSummaryURL.path.replacingOccurrences(of: "_TestSummaries.plist", with: ".xccoverage")
        return URL(fileURLWithPath: path)
    }

    static func findCodeCoverage(testSummaryURL: URL) -> [ChuteCodeCoverage] {

        var codeCoverage = [ChuteCodeCoverage]()
        
        let path = ChuteCodeCoverage.codeCoverageURL(testSummaryURL: testSummaryURL)
        guard let rawData = NSKeyedUnarchiver.unarchiveObject(withFile: path.path) as? IDESchemeActionCodeCoverage else {
            print("--- Error unarchiving xccoverage file \(path)")
            return codeCoverage
        }
        
        print("--- Code Coverage File: \(path)")
        
        for target in rawData.codeCoverageTargets {
            
            if !target.name.hasSuffix(".xctest") {
                for file in target.sourceFiles {
                    
                    var functions = [ChuteCodeCoverageFunction]()
                    for function in file.functions {
                        functions.append(ChuteCodeCoverageFunction(name: function.name as String, coverage: function.lineCoverage.doubleValue))
                    }
                    codeCoverage.append(ChuteCodeCoverage(target: target.name as String, file: file.name as String, coverage: file.lineCoverage.doubleValue, functions: functions))
                }
            }
        }
        
        return codeCoverage
    }
}
