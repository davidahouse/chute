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
//      -compareFolder          The folder to compare the results with
//      -saveFolder             The folder to save the test input data into

//      To post a summary and optional link to full report in a github pull request, the following are needed:
//      -githubRepository       The repository to use when posting a comment to github (format of <owner>/<repo>)
//      -githubToken            The token to use for posting a comment to github
//      -pullRequestNumber      The pull request number (optional)

import Foundation

struct ChuteCommandLineParameters {

    let project: String?
    let branch: String?
    let compareFolder: String?
    let saveFolder: String?

    let githubRepository: String?
    let githubToken: String?
    let pullRequestNumber: String?

    let slackWebhook: String?

    var hasRequiredParameters: Bool {
        return project != nil
    }

    var hasParametersForGithubNotification: Bool {
        return githubRepository != nil && githubToken != nil && pullRequestNumber != nil
    }

    var hasParametersForSlackNotification: Bool {
        return slackWebhook != nil
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
        compareFolder = foundArguments["compareFolder"]
        saveFolder = foundArguments["saveFolder"]

        githubRepository = foundArguments["githubRepository"]
        githubToken = foundArguments["githubToken"]
        pullRequestNumber = foundArguments["pullRequestNumber"]

        slackWebhook = foundArguments["slackWebhook"]
    }

    func printInstructions() {
        var instructions = "Usage: chute -project <project>"
        instructions += " [-branch <branch>]"
        instructions += " [-compareFolder <compareFolder>]"
        instructions += " [-saveFolder <saveFolder>]"
        instructions += " [-githubRepository <githubRepository>]"
        instructions += " [-githubToken <githubToken>]"
        instructions += " [-pullRequestNumber <pullRequestNumber>]"
        instructions += " [-slackWebhook <slackWebhook>]"
        print(instructions)
    }
}
