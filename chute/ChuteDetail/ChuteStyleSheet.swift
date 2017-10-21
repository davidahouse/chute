//
//  ChuteStyleSheet.swift
//  chute
//
//  Created by David House on 10/14/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct ChuteStyleColor: Codable {

    let red: CGFloat?
    let green: CGFloat?
    let blue: CGFloat?
    let white: CGFloat?
    let alpha: CGFloat

    var hexString: String {

        if let white = white {
            return String(format: "%02X%02X%02X", Int(white * 255), Int(white * 255), Int(white * 255))
        } else if let red = red, let green = green, let blue = blue {
            return String(format: "%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
        } else {
            return ""
        }
    }
}

struct ChuteStyleSheet: Codable {
    let viewIdentifier: String
    let viewPath: String
    let backgroundColor: ChuteStyleColor?
    let textColor: ChuteStyleColor?
    let fontName: String?
    let fontSize: CGFloat?
}
