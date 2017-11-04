//
//  SlackNotifier.swift
//  chute
//
//  Created by David House on 11/3/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class SlackNotifier {

    func notify(detail: ChuteDetail, using arguments: ChuteCommandLineParameters) {

        if let slackWebhook = arguments.slackWebhook {
            let message = SlackDetailMessage(detail: detail)
            send(message: message.message, webhook: slackWebhook)
        }
    }

    func notify(difference: ChuteDetailDifference, using arguments: ChuteCommandLineParameters) {

        if let slackWebhook = arguments.slackWebhook {
            let message = SlackDetailDifferenceMessage(difference: difference)
            send(message: message.message, webhook: slackWebhook)
        }
    }

    private func send(message: String, webhook: String) {

        // Create a URL for this request
        let urlString = webhook
        guard let postURL = URL(string: urlString) else {
            print("--- Error creating URL for posting to slack: \(urlString)")
            return
        }

        var request = URLRequest(url: postURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-type")

        let body = message.data(using: .utf8)
        request.httpBody = body

        let semaphore = DispatchSemaphore(value: 0)
        let dataTask = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request) { (data, _, error) in

            if let error = error {
                print("--- Error posting message to slack: \(error.localizedDescription)")
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
