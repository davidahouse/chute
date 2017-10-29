//
//  ChuteStyleSheet.swift
//  chute
//
//  Created by David House on 10/14/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct ChuteStyleColor: Codable {

    let red: CGFloat?
    let green: CGFloat?
    let blue: CGFloat?
    let white: CGFloat?
    let alpha: CGFloat

    var hexString: String {

        if let white = white {
            return String(format: "%02X%02X%02X", Int(white * 255), Int(white * 255), Int(white * 255))
        } else if let red = red, let green = green, let blue = blue {
            return String(format: "%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
        } else {
            return ""
        }
    }
}

struct ChuteStyleSheet: Codable {
    let viewIdentifier: String
    let viewPath: String
    let backgroundColor: ChuteStyleColor?
    let textColor: ChuteStyleColor?
    let fontName: String?
    let fontSize: CGFloat?
}

extension ChuteStyleSheet {

    static func findStyleSheets(testSummary: TestSummary, rootPath: URL) -> [ChuteStyleSheet] {

        var results = [ChuteStyleSheet]()
        for summary in testSummary.testableSummaries {
            for test in summary.tests {
                results += findStyleSheets(testDetails: test, rootPath: rootPath)
            }
        }
        return results
    }
    
    private static func findStyleSheets(testDetails: TestDetails, rootPath: URL) -> [ChuteStyleSheet] {

        var results = [ChuteStyleSheet]()

        if let activities = testDetails.activitySummaries {
            for activity in activities {
                if let attachments = activity.attachments {
                    for attachment in attachments.filter({ $0.uti == "chute.styleSheet" }) {

                        let dataPath = rootPath.appendingPathComponent(attachment.filename!)
                        do {
                            let data = try Data(contentsOf: dataPath)

                            let decoder = JSONDecoder()
                            do {
                                let styleSheet = try decoder.decode(Array<ChuteStyleSheet>.self, from: data)
                                results += styleSheet
                            } catch {
                                print(error)
                            }
                        } catch {
                            print("error loading stylesheet: \(error)")
                        }
                    }
                }
            }
        }

        if let subtests = testDetails.subtests {

            for subtest in subtests {
                results += findStyleSheets(testDetails: subtest, rootPath: rootPath)
            }
        }
        return results
    }

    static func encodedStyleSheets(from: [ChuteStyleSheet]) -> Data? {

        let encoder = JSONEncoder()
        if let data = try? encoder.encode(from) {
            return data
        } else {
            return nil
        }
    }

    static func decodedStyleSheets(path: URL) -> [ChuteStyleSheet] {

        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: path)
            let styleSheets = try decoder.decode(Array<ChuteStyleSheet>.self, from: data)
            return styleSheets
        } catch {
            print(error)
            return []
        }
    }
}
