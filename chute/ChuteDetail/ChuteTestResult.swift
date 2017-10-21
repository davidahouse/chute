//
//  ChuteTestResult.swift
//  chute
//
//  Created by David House on 10/14/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct ChuteTestResult: Encodable {

    let testIdentifier: String
    let testStatus: String

    init?(detail: TestDetails) {

        guard let testIdentifier = detail.testIdentifier,
            let testStatus = detail.testStatus else {
                return nil
        }

        self.testIdentifier = testIdentifier
        self.testStatus = testStatus
    }
}
