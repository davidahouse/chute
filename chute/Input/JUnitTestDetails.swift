//
//  JUnitTestDetails.swift
//  chute
//
//  Created by David House on 2/17/18.
//  Copyright © 2018 David House. All rights reserved.
//

import Foundation

struct JUnitTestSuite {
    let name: String
    let tests: Int
    let skipped: Int
    let failures: Int
    let errors: Int
    let timestamp: String
    let testCases: [JUnitTestCase]
}

struct JUnitTestCase {
    let name: String
    let classname: String
    let time: Double
}

class JUnitTestDetails: NSObject {

    let path: URL
    private var parser: XMLParser?
    private var currentTestSuiteAttributes: [String: String]?
    private var currentTestCases: [JUnitTestCase]
    
    var testSuites: [JUnitTestSuite]
    
    init(path: URL) {
        self.path = path
        parser = XMLParser(contentsOf: path)
        testSuites = []
        currentTestCases = []
        super.init()
        parser?.delegate = self
        parser?.parse()
    }
    
}

extension JUnitTestDetails: XMLParserDelegate {

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "testsuite" {
            currentTestSuiteAttributes = attributeDict
            currentTestCases = []
        } else if elementName == "testcase" {
            
            if let name = attributeDict["name"], let classname = attributeDict["classname"], let time = Double(attributeDict["time"] ?? "0.0") {
                let testCase = JUnitTestCase(name: name, classname: classname, time: time)
                currentTestCases.append(testCase)
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "testsuite" {
            if let attributes = currentTestSuiteAttributes, let name = attributes["name"], let tests = Int(attributes["tests"] ?? "0"), let skipped = Int(attributes["skipped"] ?? "0"), let failures = Int(attributes["failures"] ?? "0"), let errors = Int(attributes["errors"] ?? "0"), let timestamp = attributes["timestamp"] {
                
                let testSuite = JUnitTestSuite(name: name, tests: tests, skipped: skipped, failures: failures, errors: errors, timestamp: timestamp, testCases: currentTestCases)
                testSuites.append(testSuite)
            }
        }
    }
}

