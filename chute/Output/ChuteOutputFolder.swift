//
//  ChuteOutputFolder.swift
//  chute
//
//  Created by David House on 10/22/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class ChuteOutputFolder {

    private var outputFolderURL: URL {
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
