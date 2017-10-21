//
//  ChuteCodeCoverage.swift
//  chute
//
//  Created by David House on 10/14/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct ChuteCodeCoverage: Encodable {
    let target: String
    let file: String
    let coverage: Double
}
