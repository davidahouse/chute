//
//  ChuteStyleSheetDifference.swift
//  chute
//
//  Created by David House on 10/31/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct ChuteStyleSheetDifference {

    let newColors: [String]
    let removedColors: [String]
    let newFonts: [String]
    let removedFonts: [String]

    init(detail: DataCapture, comparedTo: DataCapture) {

        var detailColors = Set<String>()
        for style in detail.styleSheets {
            if let bgColor = style.backgroundColor {
                detailColors.insert(bgColor.hexString)
            }

            if let textColor = style.textColor {
                detailColors.insert(textColor.hexString)
            }
        }

        var comparedToColors = Set<String>()
        for style in comparedTo.styleSheets {
            if let bgColor = style.backgroundColor {
                comparedToColors.insert(bgColor.hexString)
            }

            if let textColor = style.textColor {
                comparedToColors.insert(textColor.hexString)
            }
        }

        newColors = Array(comparedToColors.subtracting(detailColors))
        removedColors = Array(detailColors.subtracting(comparedToColors))

        var detailFonts = Set<String>()
        for style in detail.styleSheets {
            if let fontName = style.fontName, let fontSize = style.fontSize {
                detailFonts.insert(fontName + "," + String(format: "%2.0f", fontSize))
            }
        }

        var comparedToFonts = Set<String>()
        for style in comparedTo.styleSheets {
            if let fontName = style.fontName, let fontSize = style.fontSize {
                comparedToFonts.insert(fontName + "," + String(format: "%2.0f", fontSize))
            }
        }

        newFonts = Array(comparedToFonts.subtracting(detailFonts))
        removedFonts = Array(detailFonts.subtracting(comparedToFonts))
    }
}
