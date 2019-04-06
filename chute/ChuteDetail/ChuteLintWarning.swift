//
//  ChuteLintWarning.swift
//  chute
//
//  Created by David House on 4/2/19.
//  Copyright © 2019 David House. All rights reserved.
//

import Foundation

struct ChuteLintWarning: Codable {
    let fileName: String
    let line: Int?
    let character: Int?
    let description: String
    let rule: String?
    let severity: String?
}
