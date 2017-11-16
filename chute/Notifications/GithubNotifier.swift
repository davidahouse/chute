//
//  GithubNotifier.swift
//  chute
//
//  Created by David House on 11/1/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class GithubNotifier {

    func notify(using environment: Environment, including dataCapture: DataCapture, and difference: DataCaptureDifference?) {
        
    }
    
    
//    func notify(detail: ChuteDetail, using arguments: CommandLineArguments) {
//
//        if let repository = arguments.githubRepository, let pullRequestNumber = arguments.pullRequestNumber, let token = arguments.githubToken {
//            let comment = GithubDetailComment(detail: detail)
//            send(comment: comment.comment, to: repository, for: pullRequestNumber, using: token)
//        }
//    }
//
//    func notify(difference: ChuteDetailDifference, using arguments: CommandLineArguments) {
//
//        if let repository = arguments.githubRepository, let pullRequestNumber = arguments.pullRequestNumber, let token = arguments.githubToken {
//
//            let comment = GithubDetailDifferenceComment(difference: difference)
//            send(comment: comment.comment, to: repository, for: pullRequestNumber, using: token)
//        }
//    }

    private func send(comment: String, to repository: String, for pullRequest: String, using token: String) {

        // Create a URL for this request
        let urlString = "https://api.github.com/repos/\(repository)/issues/\(pullRequest)/comments"
        guard let postURL = URL(string: urlString) else {
            print("--- Error creating URL for posting to github: \(urlString)")
            return
        }

        var request = URLRequest(url: postURL)
        request.httpMethod = "POST"
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")

        let body: [String: String] = [
            "body": comment
        ]
        let encoder = JSONEncoder()
        do {
            let rawBody = try encoder.encode(body)
            request.httpBody = rawBody
        } catch {
            print("--- Error encoding body: \(error)")
        }

        let semaphore = DispatchSemaphore(value: 0)
        let dataTask = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request) { (data, _, error) in

            if let error = error {
                print("--- Error posting comment to github: \(error.localizedDescription)")
            }

            if let data = data {
                let dataString = String(data: data, encoding: .utf8)
                print("--- Response: \(dataString ?? "")")
            }
            semaphore.signal()
        }
        dataTask.resume()
        _ = semaphore.wait(timeout: DispatchTime.now() + DispatchTimeInterval.seconds(30))
    }
}
