//
//  ChuteOutput.swift
//  chute
//
//  Created by David House on 10/20/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct ChuteOutputDetail {
    let rootPath: URL
    let detail: ChuteDetail
    let attachments: [ChuteTestAttachment]
    let styleSheets: [ChuteStyleSheet]
}

protocol ChuteOutputRenderable {
    func render(detail: ChuteOutputDetail) -> String
}

class ChuteOutput {

    private var outputFolder: URL {
        let currentFolderURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let outputFolderURL = currentFolderURL.appendingPathComponent("chute_output")
        do {
            try FileManager.default.createDirectory(at: outputFolderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Erorr creating directory \(error)")
        }
        return outputFolderURL
    }

    private var attachmentFolder: URL {

        let rootFolderURL = outputFolder
        let attachmentFolderURL = rootFolderURL.appendingPathComponent("attachments")
        do {
            try FileManager.default.createDirectory(at: attachmentFolderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Erorr creating directory \(error)")
        }
        return attachmentFolderURL
    }

    func renderHTMLOutput(detail: ChuteOutputDetail) {

        saveAttachments(rootPath: detail.rootPath, attachments: detail.attachments)

        let reports: [String: ChuteOutputRenderable] = [
            "chute.html": ChuteHTMLMainReport(),
            "test_details.html": ChuteHTMLTestDetailReport(),
            "code_coverage.html": ChuteHTMLCodeCoverageReport(),
            "style_sheet.html": ChuteHTMLStyleSheetReport()
        ]
        render(reports, with: detail)
    }

    func renderMarkdownOutput(detail: ChuteOutputDetail) {

        saveAttachments(rootPath: detail.rootPath, attachments: detail.attachments)

        let reports: [String: ChuteOutputRenderable] = [
            "chute.md": ChuteMarkdownMainReport(),
            "chuteTestDetail.md": ChuteMarkdownTestDetailReport()
        ]
        render(reports, with: detail)
    }

    private func render(_ reports: [String: ChuteOutputRenderable], with detail: ChuteOutputDetail) {

        reports.forEach {
            let output = $0.value.render(detail: detail)
            saveOutputFile(fileName: $0.key, contents: output)
        }
    }

    private func saveOutputFile(fileName: String, contents: String) {
        guard let outputData = contents.data(using: .utf8) else {
            return
        }

        let outputFileURL = outputFolder.appendingPathComponent(fileName)
        do {
            try outputData.write(to: outputFileURL)
        } catch {
            print("Error writing output \(error)")
        }
    }

    private func saveAttachments(rootPath: URL, attachments: [ChuteTestAttachment]) {

        for attachment in attachments {

            let filePath = rootPath.appendingPathComponent(attachment.attachmentFileName)
            guard let imageData = try? Data(contentsOf: filePath) else {
                preconditionFailure("Unable to load image data from \(filePath)")
            }

            let outputPath = attachmentFolder.appendingPathComponent(attachment.attachmentFileName)
            do {
                try imageData.write(to: outputPath)
            } catch {
                print("error writing attachment: \(error)")
            }
        }
    }
}
