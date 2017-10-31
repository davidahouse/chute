//
//  ChuteHTMLStyleSheetDifferenceReport.swift
//  chute
//
//  Created by David House on 10/31/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class ChuteHTMLStyleSheetDifferenceReport: ChuteOutputDifferenceRenderable {

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
            <th>Colors Added</th>
            <th></th>
            </thead>
            <tbody>
            {{colors_added}}
            </tbody>
            </table>
            </div>
            <div class="table-responsive">
            <table class="table">
            <thead>
            <th>Colors Removed</th>
            <th></th>
            </thead>
            <tbody>
            {{colors_removed}}
            </tbody>
            </table>
            </div>
            </div>
            <div class="jumbotron">
            <h3>Fonts</h3>
            <div class="table-responsive">
            <table class="table">
            <thead>
            <th>Font Added</th>
            <th></th>
            </thead>
            <tbody>
            {{fonts_added}}
            </tbody>
            </table>
            </div>
            <div class="table-responsive">
            <table class="table">
            <thead>
            <th>Font Removed</th>
            <th></th>
            </thead>
            <tbody>
            {{fonts_removed}}
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

    func render(difference: ChuteDetailDifference) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "title": "Chute Report",
            "report": reportContents(difference: difference)
        ]
        return ChuteHTMLOutputTemplateConstants.Template.render(parameters: parameters)
    }

    private func reportContents(difference: ChuteDetailDifference) -> String {

        let parameters: [String: CustomStringConvertible] = [
            "colors_added": reportColors(colors: difference.styleSheetDifference.newColors),
            "colors_removed": reportColors(colors: difference.styleSheetDifference.removedColors),
            "fonts_added": reportFonts(fonts: difference.styleSheetDifference.newFonts),
            "fonts_removed": reportFonts(fonts: difference.styleSheetDifference.removedFonts)
        ]
        return Constants.Template.render(parameters: parameters)
    }

    private func reportColors(colors: [String]) -> String {

        var output = ""

        for color in colors.sorted() {
            let parameters: [String: CustomStringConvertible] = [
                "color": color
            ]
            output += Constants.ColorTemplate.render(parameters: parameters)
        }
        return output
    }

    private func reportFonts(fonts: [String]) -> String {

        var output = ""

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
