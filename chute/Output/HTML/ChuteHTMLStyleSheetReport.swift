//
//  ChuteHTMLStyleSheetReport.swift
//  chute
//
//  Created by David House on 10/20/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class ChuteHTMLStyleSheetReport: ChuteOutputRenderable {

    enum Constants {
        static let Template = """
            <div class="jumbotron">
            <h1>Chute Style Sheet Report</h1>
            </div>
            <div class="jumbotron">
            <h3>Colors</h3>
            <div class="table-responsive">
            <table class="table">
            <thead>
            <th>Color</th>
            <th></th>
            </thead>
            <tbody>
            {{colors}}
            </tbody>
            </table>
            </div>
            </div>
            <div class="jumbotron">
            <h3>Fonts</h3>
            <div class="table-responsive">
            <table class="table">
            <thead>
            <th>Font</th>
            <th>Size</th>
            </thead>
            <tbody>
            {{fonts}}
            </tbody>
            </table>
            </div>
            </div>
        """

        static let ColorTemplate = """
            <tr><td>
            <div class="color-swatch" style="background-color:#{{color}};float: left;width: 60px;height: 60px;margin: 0 5px;border-radius: 3px">
            </div></td><td>#{{color}}</td></tr>
        """

        static let FontTemplate = """
            <tr><td>{{font}}</td><td>{{size}}</td></tr>
        """
    }
    
    func render(detail: ChuteOutputDetail) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "title": "Chute Report",
            "report": reportContents(detail: detail)
        ]
        return ChuteHTMLOutputTemplateConstants.Template.render(parameters: parameters)
    }

    private func reportContents(detail: ChuteOutputDetail) -> String {

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
