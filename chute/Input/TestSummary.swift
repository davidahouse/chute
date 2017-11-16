//
//  TestSummary.swift
//  chute
//
//  Created by David House on 9/3/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct ActivityAttachmentUserInfo: Decodable {
    let scale: Int

    enum CodingKeys: String, CodingKey {
        case scale = "Scale"
    }
}

struct ActivityAttachment: Decodable {
    let filename: String?
    let hasPayload: Bool?
    let inActivityIdentifier: Int?
    let lifetime: Int?
    let name: String?
    let timestamp: Double?
    let uti: String?
    let userInfo: ActivityAttachmentUserInfo?

    enum CodingKeys: String, CodingKey {
        case filename = "Filename"
        case hasPayload = "HasPayload"
        case inActivityIdentifier = "InActivityIdentifier"
        case lifetime = "Lifetime"
        case name = "Name"
        case timestamp = "Timestamp"
        case uti = "UniformTypeIdentifier"
        case userInfo = "UserInfo"
    }
}

struct ActivitySummary: Decodable {
    let activityType: String
    let attachments: [ActivityAttachment]?

    enum CodingKeys: String, CodingKey {
        case activityType = "ActivityType"
        case attachments = "Attachments"
    }
}

struct TestableSummary: Decodable {
    let projectPath: String
    let targetName: String
    let testName: String
    let testObjectClass: String
    let tests: [TestDetails]

    enum CodingKeys: String, CodingKey {
        case projectPath = "ProjectPath"
        case targetName = "TargetName"
        case testName = "TestName"
        case testObjectClass = "TestObjectClass"
        case tests = "Tests"
    }
}

struct TestDetails: Decodable {
    let duration: Double
    let testIdentifier: String?
    let testName: String?
    let testObjectClass: String?
    let testStatus: String?
    let testSummaryGuid: String?
    let subtests: [TestDetails]?
    let activitySummaries: [ActivitySummary]?

    enum CodingKeys: String, CodingKey {
        case duration = "Duration"
        case testIdentifier = "TestIdentifier"
        case testName = "TestName"
        case testObjectClass = "TestObjectClass"
        case testStatus = "TestStatus"
        case testSummaryGuid = "TestSummaryGuid"
        case subtests = "Subtests"
        case activitySummaries = "ActivitySummaries"
    }
}

struct TestSummary: Decodable {
    let formatVersion: String
    let testableSummaries: [TestableSummary]

    enum CodingKeys: String, CodingKey {
        case formatVersion = "FormatVersion"
        case testableSummaries = "TestableSummaries"
    }
}

struct TestSummaryFolder {
    let createDate: Date
    let folderURL: URL
    let summaryFileURL: URL
    let summary: TestSummary
    let attachmentRootURL: URL
}

extension TestSummaryFolder: Printable {
    
    func printOut() {
        print("CreateDate: \(createDate)")
        print("FolderURL: \(folderURL)")
        print("SummaryFileURL: \(summaryFileURL)")
    }
}

extension TestSummary {

    static func summaries(in folder: URL) -> [TestSummaryFolder] {

        var found = [TestSummaryFolder]()
        let testsFolder = folder.appendingPathComponent("Logs").appendingPathComponent("Test")
        if let paths = try? FileManager.default.contentsOfDirectory(at: testsFolder, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants) {

            for path in paths {
                if path.lastPathComponent.hasSuffix("plist") {
                    if let summary = TestSummary.from(file: testsFolder.appendingPathComponent(path.lastPathComponent)) {

                        let createDateResource: Set<URLResourceKey> = [URLResourceKey.creationDateKey]
                        let createDate = try? path.resourceValues(forKeys: createDateResource)

                        if let createDate = createDate?.creationDate {
                            let foundFolderURL = testsFolder.appendingPathComponent(path.lastPathComponent)
                            let attachmentRootURL = foundFolderURL.deletingLastPathComponent().appendingPathComponent("Attachments")
                            let foundFolder = TestSummaryFolder(createDate: createDate, folderURL: foundFolderURL, summaryFileURL: testsFolder.appendingPathComponent(path.lastPathComponent), summary: summary, attachmentRootURL: attachmentRootURL)
                            found.append(foundFolder)
                        }
                    }
                }
            }
        }
        return found
    }

    static func from(file: URL) -> TestSummary? {
        if let data = try? Data(contentsOf: file) {
            let decoder = PropertyListDecoder()
            do {
                let plist = try decoder.decode(TestSummary.self, from: data)
                return plist
            } catch {
                print(error)
            }
        }
        return nil
    }
}
