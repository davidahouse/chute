//
//  DifferenceReportSummaryStyleSheet.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct DifferenceReportSummaryStyleSheet: ChuteOutputDifferenceRenderable {
    
    enum Constants {
        static let Template = """
        <div class="summary-2-column">
            <div class="summary-item alert alert-info">
                <div class="summary-item-text"><h1>{{new_colors}}</h1></div>
                <div class="summary-item-text"><h3>New Colors</h3></div>
            </div>

            <div class="summary-item alert alert-success">
                <div class="summary-item-text"><h1>{{removed_colors}}</h1></div>
                <div class="summary-item-text"><h3>Removed Colors</h3></div>
            </div>
        </div>

        <div class="summary-2-column">
            <div class="summary-item alert alert-info">
                <div class="summary-item-text"><h1>{{new_fonts}}</h1></div>
                <div class="summary-item-text"><h3>New Fonts</h3></div>
            </div>

            <div class="summary-item alert alert-success">
                <div class="summary-item-text"><h1>{{removed_fonts}}</h1></div>
                <div class="summary-item-text"><h3>Removed Fonts</h3></div>
            </div>
        </div>
        """
    }
    
    func render(difference: DataCaptureDifference) -> String {
        
        let parameters: [String: CustomStringConvertible] = [
            "new_colors": difference.styleSheetDifference.newColors.count,
            "removed_colors": difference.styleSheetDifference.removedColors.count,
            "new_fonts": difference.styleSheetDifference.newFonts.count,
            "removed_fonts": difference.styleSheetDifference.removedFonts.count
        ]
        return Constants.Template.render(parameters: parameters)
    }
}
