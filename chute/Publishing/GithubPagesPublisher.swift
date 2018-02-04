//
//  GithubPagesPublisher.swift
//  chute
//
//  Created by David House on 11/24/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class GithubPagesPublisher {
    
    let environment: Environment
    let outputFolder: ChuteOutputFolder
    let testExecutionDate: Date
    
    lazy var publishRootURL: URL = {
        let tmpFolder = NSTemporaryDirectory()
        let tmpFolderURL = URL(fileURLWithPath: tmpFolder)
        return tmpFolderURL.appendingPathComponent("chute")
    }()
    
    lazy var publishClonedURL: URL = {
        return self.publishRootURL.appendingPathComponent("gh-pages")
    }()
    
    lazy var publishExecutionRootURL: URL = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let folderName = formatter.string(from: testExecutionDate)
        return self.publishClonedURL.appendingPathComponent(folderName)
    }()
    
    init(environment: Environment, outputFolder: ChuteOutputFolder, testExecutionDate: Date) {
        self.environment = environment
        self.outputFolder = outputFolder
        self.testExecutionDate = testExecutionDate
    }

    func publish() {
        
        guard let repository = environment.arguments.githubRepository else {
            return
        }
        
        // Remove any existing /tmp/chute folder
        do {
            try FileManager.default.removeItem(at: publishRootURL)
        } catch { }
        
        // Create /tmp/chute folder
        do {
            try FileManager.default.createDirectory(at: publishRootURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Erorr creating directory \(error)")
        }
        print("Publish root folder: \(publishRootURL)")
        
        // Do a git clone from the repo using gh-pages branch into /tmp/chute
        let output = Execute.shell(command: ["-l", "-c", "cd \(publishRootURL.path) && git clone -b gh-pages git@\(environment.arguments.githubHost ?? "github.com"):\(repository).git gh-pages"])
        print(output ?? "")
        
        // Copy the reports & attachments
        do {
            try FileManager.default.copyItem(at: outputFolder.outputFolderURL, to: publishExecutionRootURL)
        } catch {
            print("Error copying output folder")
        }
        print("Copied chute output folder to tmp folder")
        
        // Git add, commit and push
        let gitAddOutput = Execute.shell(command: ["-l", "-c", "cd \(publishClonedURL.path) && git add ."])
        print(gitAddOutput ?? "")

        let gitCommitOutput = Execute.shell(command: ["-l", "-c", "cd \(publishClonedURL.path) && git commit -m \"Chute test execution publish\""])
        print(gitCommitOutput ?? "")

        let gitPushOutput = Execute.shell(command: ["-l", "-c", "cd \(publishClonedURL.path) && git push"])
        print(gitPushOutput ?? "")

        // Remove temporary folder
        do {
            try FileManager.default.removeItem(at: publishRootURL)
        } catch { }
    }
}
