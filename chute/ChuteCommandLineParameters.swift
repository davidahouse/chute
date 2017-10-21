//
//  ChuteCommandLine.swift
//  chute
//
//  Created by David House on 9/10/17.
//  Copyright © 2017 David House. All rights reserved.
//

//  Chute Command Line Reference:
//
//  chute
//      -project                The Xcode project to use when creating the Chute report
//      -branch                 The branch that resprents the captured test results
//      -pullRequestNumber      The pull request number (optional)
//      -compareFolder          The folder to compare the results with
//      -saveFolder             The folder to save the test input data into

import Foundation

struct ChuteCommandLineParameters {

    let project: String?
    let branch: String?
    let pullRequestNumber: String?
    let compareFolder: String?
    let saveFolder: String?

    var hasRequiredParameters: Bool {
        return project != nil
    }

    init(arguments: [String] = CommandLine.arguments) {

        var foundArguments: [String: String] = [:]
        for (index, value) in arguments.enumerated() {

            if value.hasPrefix("-") && index < (arguments.count - 1) && !arguments[index+1].hasPrefix("-") {
                let parameter = String(value.suffix(value.count - 1))
                foundArguments[parameter] = arguments[index+1]
            }
        }

        project = foundArguments["project"]
        branch = foundArguments["branch"]
        pullRequestNumber = foundArguments["pullRequestNumber"]
        compareFolder = foundArguments["compareFolder"]
        saveFolder = foundArguments["saveFolder"]
    }

    func printInstructions() {
        print("Usage: chute -project <project> [-branch <branch>] [-pullRequestNumber <pullRequestNumber> [-compareFolder <compareFolder>] [-saveFolder <saveFolder>]")
    }
}
