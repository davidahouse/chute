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
        print("Publish execution url: \(publishExecutionRootURL())")
        
        // Do a git clone from the repo using gh-pages branch into /tmp/chute
        let output = Execute.shell(command: ["-l", "-c", "cd \(publishRootURL.path) && git clone -b gh-pages git@\(environment.arguments.githubHost ?? "github.com"):\(repository).git gh-pages"])
        print(output ?? "")
        
        // Erase any existing output at our publish url but ignore errors since this
        // folder might not exist yet
        do {
            try FileManager.default.removeItem(at: publishExecutionRootURL())
        } catch { }
        
        // Copy the reports & attachments
        do {
            try FileManager.default.copyItem(at: outputFolder.outputFolderURL, to: publishExecutionRootURL())
        } catch {
            print("Error copying output folder: \(error.localizedDescription)")
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
    
    private func publishExecutionRootURL() -> URL {

        let folderName: String = {
            
            if let pullRequestNumber = arguments.pullRequestNumber {
                return pullRequestNumber
            } else if let branch = arguments.branch {
                return branch
            } else {
                return "chute"
            }
        }()
        
        return self.publishClonedURL.appendingPathComponent(folderName)
    }
}
