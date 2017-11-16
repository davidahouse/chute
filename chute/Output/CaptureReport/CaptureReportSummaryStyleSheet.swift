//
//  CaptureReportSummaryStyleSheet.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct CaptureReportSummaryStyleSheet: ChuteOutputRenderable {
    
    enum Constants {
        static let StyleSheetSummaryRowTemplate = """
        <tr>
        <td>StyleSheet:</td>
        <td>Colors Found: {{total_colors}}</td>
        <td>Fonts Found: {{total_fonts}}</td>
        </tr>
        """
    }
    
    func render(dataCapture: DataCapture) -> String {
        
        var colors = Set<String>()
        for style in dataCapture.styleSheets {
            if let bgColor = style.backgroundColor {
                colors.insert(bgColor.hexString)
            }
            
            if let textColor = style.textColor {
                colors.insert(textColor.hexString)
            }
        }
        
        var fonts = Set<String>()
        for style in dataCapture.styleSheets {
            if let fontName = style.fontName, let fontSize = style.fontSize {
                fonts.insert(fontName + "," + String(format: "%2.0f", fontSize))
            }
        }
        
        let parameters: [String: CustomStringConvertible] = [
            "total_colors": colors.count,
            "total_fonts": fonts.count
        ]
        return Constants.StyleSheetSummaryRowTemplate.render(parameters: parameters)
    }
}
