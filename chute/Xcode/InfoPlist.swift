//
//  InfoPlist.swift
//  chute
//
//  Created by David House on 9/3/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct InfoPlist: Codable {
    let lastAccessDate: Date?
    let workspacePath: String

    enum CodingKeys: String, CodingKey {
        case lastAccessDate = "LastAccessedDate"
        case workspacePath = "WorkspacePath"
    }
}

extension InfoPlist {

    static func from(file: URL) -> InfoPlist? {
        
        guard FileManager.default.fileExists(atPath: file.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: file)
            let decoder = PropertyListDecoder()
            do {
                let plist = try decoder.decode(InfoPlist.self, from: data)
                return plist
            } catch {
                print(error)
            }
        } catch {
            print("Error reading plist file: \(error)")
        }
        return nil
    }
}
