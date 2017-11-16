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
        <tr>
        <td>StyleSheet:</td>
        <td class="info">Colors Added: {{new_colors}}</td>
        <td class="info">Colors Removed: {{removed_colors}}</td>
        <td class="info">Fonts Added: {{new_fonts}}</td>
        <td class="info">Fonts Removed: {{removed_fonts}}</td>
        </tr>
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
