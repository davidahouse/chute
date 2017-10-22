//
//  ChuteMarkdownTestSummaryOutput.swift
//  chute
//
//  Created by David House on 10/20/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class ChuteMarkdownTestSummaryOutput: ChuteOutputRenderable {

    enum Constants {
        static let Template: String = """

        """
    }

    func render(detail: ChuteDetail) -> String {
        return Constants.Template.render(parameters: [:])
    }
}
