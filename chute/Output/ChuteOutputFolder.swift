//
//  ChuteOutputFolder.swift
//  chute
//
//  Created by David House on 10/22/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class ChuteOutputFolder {

    var outputFolderURL: URL {
        let currentFolderURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        return currentFolderURL.appendingPathComponent("chute_output")
    }

    private var attachmentFolderURL: URL {

        return outputFolderURL.appendingPathComponent("attachments")
    }

    private var sourceFolderURL: URL {

        return outputFolderURL.appendingPathComponent("source")
    }

    func empty() {

        do {
            try FileManager.default.removeItem(at: outputFolderURL)
        } catch { }

        do {
            try FileManager.default.createDirectory(at: outputFolderURL, withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.createDirectory(at: attachmentFolderURL, withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.createDirectory(at: sourceFolderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Erorr creating directory \(error)")
        }
    }
    
    func populate(using environment: Environment, including dataCapture: DataCapture, and difference: DataCaptureDifference?) {
        
        guard let testExecutionFolder = environment.derivedData?.mostRecentTestSummary else {
            return
        }
        
        saveAttachments(rootPath: testExecutionFolder.attachmentRootURL, attachments: dataCapture.attachments)
        saveSourceFile(from: testExecutionFolder.summaryFileURL, to: "TestSummaries.plist")
        saveSourceFile(from: ChuteCodeCoverage.codeCoverageURL(testSummaryURL: testExecutionFolder.summaryFileURL), to: "codeCoverage.xccovreport")
        if let styleSheetData = ChuteStyleSheet.encodedStyleSheets(from: dataCapture.styleSheets) {
            saveSourceFile(fileName: "stylesheets.data", data: styleSheetData)
        }
        
        // TODO: Save changed attachments here too!
        if let viewDifference = difference?.viewDifference, let attachmentRootURL = difference?.detail.attachmentRootURL {
            saveChangedAttachments(rootPath: attachmentRootURL, attachments: viewDifference.changedViews.map { $0.1 })
        }
    }

    func saveOutputFile(fileName: String, contents: String) {
        guard let outputData = contents.data(using: .utf8) else {
            return
        }
        saveOutputFile(fileName: fileName, data: outputData)
    }

    func saveOutputFile(fileName: String, data: Data) {
        let outputFileURL = outputFolderURL.appendingPathComponent(fileName)
        do {
            try data.write(to: outputFileURL)
        } catch {
            print("Error writing output \(error)")
        }
    }

    func saveAttachments(rootPath: URL, attachments: [ChuteTestAttachment]) {

        for attachment in attachments {

            let filePath = rootPath.appendingPathComponent(attachment.attachmentFileName)
            guard let imageData = try? Data(contentsOf: filePath) else {
                preconditionFailure("Unable to load image data from \(filePath)")
            }

            let outputPath = attachmentFolderURL.appendingPathComponent(attachment.attachmentFileName)
            do {
                try imageData.write(to: outputPath)
            } catch {
                print("error writing attachment: \(error)")
            }
        }
    }
    
    func saveChangedAttachments(rootPath: URL, attachments: [ChuteTestAttachment]) {
        
        for attachment in attachments {
            
            let filePath = rootPath.appendingPathComponent(attachment.attachmentFileName)
            guard let imageData = try? Data(contentsOf: filePath) else {
                preconditionFailure("Unable to load image data from \(filePath)")
            }
            
            let outputPath = attachmentFolderURL.appendingPathComponent("before_" + attachment.attachmentFileName)
            do {
                try imageData.write(to: outputPath)
            } catch {
                print("error writing attachment: \(error)")
            }
        }
    }

    func saveSourceFile(from: URL, to fileName: String) {

        do {
            let data = try Data(contentsOf: from)
            let outputURL = sourceFolderURL.appendingPathComponent(fileName)
            try data.write(to: outputURL)
        } catch {
            print("Error saving source file: \(error)")
        }
    }

    func saveSourceFile(fileName: String, data: Data) {
        let outputFileURL = sourceFolderURL.appendingPathComponent(fileName)
        do {
            try data.write(to: outputFileURL)
        } catch {
            print("Error writing output \(error)")
        }
    }
}
