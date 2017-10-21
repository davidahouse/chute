//
//  URL+Extensions.swift
//  chute
//
//  Created by David House on 10/14/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

extension URL {

    func appendingPathComponents(_ components: [String]) -> URL {

        if components.count > 0 {
            return self.appendingPathComponent(components.first!).appendingPathComponents(Array(components.dropFirst()))
        } else {
            return self
        }
    }
}
