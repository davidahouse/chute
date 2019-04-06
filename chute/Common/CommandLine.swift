//
//  CommandLine.swift
//  chute
//
//  Created by David House on 9/10/17.
//  Copyright © 2017 David House. All rights reserved.
//

//  Chute Command Line Reference:
//
//  chute
//      -platform               iOS or Android
//      -project                The Xcode project to use when creating the Chute report
//      -branch                 The branch that resprents the captured test results
//      -compareFolder          The folder to compare the results with
//      -saveFolder             The folder to save the test input data into

//      To post a summary and optional link to full report in a github pull request, the following are needed:
//      -githubRepository       The repository to use when posting a comment to github (format of <owner>/<repo>)
//      -githubToken            The token to use for posting a comment to github
//      -pullRequestNumber      The pull request number (optional)
//      -githubPagesFolder      The root folder in Github Pages branch for publishing to
//
//      -publishRootURL         The root http url where the published files will be found
//      -githubHost             The host name if using github enterprise
//      -githubAPIURL           The API URL if using github enterprise

//      -derivedDataFolder      Root folder for DerivedData
//      -buildFolder            Root folder for Android builds
//      -logLevel               Determines if additional logs will be written
//      -buildLogFile           The specific path to the build log where we can find warnings and compiler errors
//      -swiftLintLog           The path to the swift lint log file
//      -inferReport            The path to the infer report file
import Foundation

struct CommandLineArguments {

    let platform: String?
    let project: String?
    let branch: String?
    let compareFolder: String?

    let githubRepository: String?
    let githubToken: String?
    let pullRequestNumber: String?
    let githubPagesFolder: String?
    let githubHost: String?
    let githubAPIURL: String?
    
    let slackWebhook: String?

    let publishRootURL: String?
    
    let derivedDataFolder: String?
    let buildFolder: String?
    let logLevel: String?
    let buildLogFile: String?
    let swiftLintLog: String?
    let inferReport: String?
    
    var hasRequiredParameters: Bool {
        return project != nil && platform != nil
    }

    var hasParametersForGithubNotification: Bool {
        return githubRepository != nil && githubToken != nil && pullRequestNumber != nil
    }

    var hasParametersForSlackNotification: Bool {
        return slackWebhook != nil
    }
    
    var hasParametersForGithubPagesPublish: Bool {
        return githubRepository != nil && githubToken != nil && githubPagesFolder != nil
    }

    init(arguments: [String] = CommandLine.arguments) {

        var foundArguments: [String: String] = [:]
        for (index, value) in arguments.enumerated() {

            if value.hasPrefix("-") && index < (arguments.count - 1) && !arguments[index+1].hasPrefix("-") {
                let parameter = String(value.suffix(value.count - 1))
                foundArguments[parameter] = arguments[index+1]
            }
        }

        platform = foundArguments["platform"]
        project = foundArguments["project"]
        branch = foundArguments["branch"] != nil ? foundArguments["branch"] : ProcessInfo.processInfo.environment["CHUTE_BRANCH"]
        compareFolder = foundArguments["compareFolder"] != nil ? foundArguments["compareFolder"] : ProcessInfo.processInfo.environment["CHUTE_COMPARE_FOLDER"]

        githubRepository = foundArguments["githubRepository"] != nil ? foundArguments["githubRepository"] : ProcessInfo.processInfo.environment["CHUTE_GITHUB_REPOSITORY"]
        githubToken = foundArguments["githubToken"] != nil ? foundArguments["githubToken"] : ProcessInfo.processInfo.environment["CHUTE_GITHUB_TOKEN"]
        pullRequestNumber = foundArguments["pullRequestNumber"] != nil ? foundArguments["pullRequestNumber"] : ProcessInfo.processInfo.environment["CHUTE_PULL_REQUEST_NUMBER"]
        githubPagesFolder = foundArguments["githubPagesFolder"] != nil ? foundArguments["githubPagesFolder"] : ProcessInfo.processInfo.environment["CHUTE_GITHUB_PAGES_FOLDER"]

        slackWebhook = foundArguments["slackWebhook"] != nil ? foundArguments["slackWebhook"] : ProcessInfo.processInfo.environment["CHUTE_SLACK_WEBHOOK"]
        
        publishRootURL = foundArguments["publishRootURL"] != nil ? foundArguments["publishRootURL"] : ProcessInfo.processInfo.environment["CHUTE_PUBLISH_ROOT_URL"]
        
        githubHost = foundArguments["githubHost"] != nil ? foundArguments["githubHost"] : ProcessInfo.processInfo.environment["CHUTE_GITHUB_HOST"]
        githubAPIURL = foundArguments["githubAPIURL"] != nil ? foundArguments["githubAPIURL"] : ProcessInfo.processInfo.environment["CHUTE_GITHUB_APIURL"]
        
        derivedDataFolder = foundArguments["derivedDataFolder"] != nil ? foundArguments["derivedDataFolder"] : ProcessInfo.processInfo.environment["CHUTE_DERIVED_DATA_FOLDER"]
        buildFolder = foundArguments["buildFolder"] != nil ? foundArguments["buildFolder"] : ProcessInfo.processInfo.environment["CHUTE_BUILD_FOLDER"]
        logLevel = foundArguments["logLevel"] != nil ? foundArguments["logLevel"] : ProcessInfo.processInfo.environment["CHUTE_LOG_LEVEL"]
        buildLogFile = foundArguments["buildLogFile"] != nil ? foundArguments["buildLogFile"] :
            ProcessInfo.processInfo.environment["CHUTE_BUILD_LOG_FILE"]
        swiftLintLog = foundArguments["swiftLintLog"] != nil ? foundArguments["swiftLintLog"] :
            ProcessInfo.processInfo.environment["CHUTE_SWIFT_LINT_LOG"]
        inferReport = foundArguments["inferReport"] != nil ? foundArguments["inferReport"] : ProcessInfo.processInfo.environment["CHUTE_INFER_REPORT"]
    }

    func printInstructions() {
        var instructions = "Usage: chute -platform <platform> -project <project>"
        instructions += " [-branch <branch>]"
        instructions += " [-compareFolder <compareFolder>]"
        instructions += " [-githubRepository <githubRepository>]"
        instructions += " [-githubToken <githubToken>]"
        instructions += " [-pullRequestNumber <pullRequestNumber>]"
        instructions += " [-githubPagesFolder <githubPagesFolder>]"
        instructions += " [-slackWebhook <slackWebhook>]"
        instructions += " [-publishRootURL <publishRootURL>]"
        instructions += " [-githubHost <githubHost>]"
        instructions += " [-githubAPIURL <githubAPIURL>]"
        instructions += " [-derivedDataFolder <derivedDataFolder>]"
        instructions += " [-buildFolder <buildFolder>]"
        instructions += " [-logLevel <logLevel>]"
        instructions += " [-buildLogFile <buildLogFile>]"
        instructions += " [-swiftLintLog <swiftLintLog>]"
        instructions += " [-inferReport <inferReport>"
        print(instructions)
    }
}

extension CommandLineArguments: Printable {

    func printOut() {
        print("Platform: \(platform ?? "")")
        print("Project: \(project ?? "")")
        print("Branch: \(branch ?? "")")
        print("Compare Folder: \(compareFolder ?? "")")
        print("Github Repository: \(githubRepository ?? "")")
        print("Github Token: \(githubToken ?? "")")
        print("PR Number: \(pullRequestNumber ?? "")")
        print("Github Pages Folder: \(githubPagesFolder ?? "")")
        print("Slack Webhook: \(slackWebhook ?? "")")
        print("Publish Root URL: \(publishRootURL ?? "")")
        print("Github Host: \(githubHost ?? "")")
        print("Github API URL: \(githubAPIURL ?? "")")
        print("Derived Data Folder: \(derivedDataFolder ?? "")")
        print("Build Folder: \(buildFolder ?? "")")
        print("Log Level: \(logLevel ?? "")")
        print("Build Log File: \(buildLogFile ?? "")")
        print("Swift Lint Log: \(swiftLintLog ?? "")")
        print("Infer Report: \(inferReport ?? "")")
    }
}
