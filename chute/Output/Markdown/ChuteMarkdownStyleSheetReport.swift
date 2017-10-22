//
//  ChuteMarkdownStyleSheetReport.swift
//  chute
//
//  Created by David House on 10/22/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class ChuteMarkdownStyleSheetReport: ChuteOutputRenderable {

    enum Constants {
        static let Template = """
        # Style Sheet Report

        ## Colors

        | Color |
        |-------|
        {{colors}}

        ## Fonts

        | Font | Size |
        |------|------|
        {{fonts}}
        """

        static let ColorTemplate = """
        | #{{color}} |

        """

        static let FontTemplate = """
        | {{font}} | {{size}} |

        """
    }

    func render(detail: ChuteOutputDetail) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "colors": reportColors(detail: detail),
            "fonts": reportFonts(detail: detail)
        ]
        return Constants.Template.render(parameters: parameters)
    }

    private func reportColors(detail: ChuteOutputDetail) -> String {

        var output = ""

        var colors = Set<String>()
        for style in detail.styleSheets {
            if let bgColor = style.backgroundColor {
                colors.insert(bgColor.hexString)
            }

            if let textColor = style.textColor {
                colors.insert(textColor.hexString)
            }
        }

        for color in colors.sorted() {
            let parameters: [String: CustomStringConvertible] = [
                "color": color
            ]
            output += Constants.ColorTemplate.render(parameters: parameters)
        }
        return output
    }

    private func reportFonts(detail: ChuteOutputDetail) -> String {

        var output = ""

        var fonts = Set<String>()
        for style in detail.styleSheets {
            if let fontName = style.fontName, let fontSize = style.fontSize {
                fonts.insert(fontName + "," + String(format: "%2.0f", fontSize))
            }
        }

        for font in fonts.sorted() {
            let parts = font.components(separatedBy: ",")
            let parameters: [String: CustomStringConvertible] = [
                "font": parts[0],
                "size": parts[1]
            ]
            output += Constants.FontTemplate.render(parameters: parameters)
        }
        return output
    }
}
