//
//  Render.swift
//  chute
//
//  Created by David House on 10/20/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

public extension String {

    func render(parameters: [String: CustomStringConvertible]) -> String {

        var output = self
        for (key, value) in parameters {
            output = output.replacingOccurrences(of: "{{\(key)}}", with: value.description)
        }
        return output
    }
}
