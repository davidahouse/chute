//
//  ChuteTestExtensions.swift
//  ChuteExampleTests
//
//  Created by David House on 10/21/17.
//  Copyright © 2017 David House. All rights reserved.
//

import UIKit
import XCTest

struct StyleColor: Codable {

    let red: CGFloat?
    let green: CGFloat?
    let blue: CGFloat?
    let white: CGFloat?
    let alpha: CGFloat

    init?(_ color: UIColor) {

        guard let components = color.cgColor.components else {
            return nil
        }

        if components.count == 2 {
            white = components[0]
            alpha = components[1]
            red = nil
            green = nil
            blue = nil
        } else {
            red = components[0]
            green = components[1]
            blue = components[2]
            alpha = components[3]
            white = nil
        }
    }
}

struct StyleSheet: Codable {
    let viewIdentifier: String
    let viewPath: String
    let backgroundColor: StyleColor?
    let textColor: StyleColor?
    let fontName: String?
    let fontSize: CGFloat?

    init(identifier: String, path: String, view: UIView) {

        viewIdentifier = identifier
        viewPath = path

        if let bgColor = view.backgroundColor {
            backgroundColor = StyleColor(bgColor)
        } else {
            backgroundColor = nil
        }

        if let label = view as? UILabel {
            textColor = StyleColor(label.textColor)
            fontName = label.font.fontName
            fontSize = label.font.pointSize
        } else {
            textColor = nil
            fontName = nil
            fontSize = nil
        }
    }
}

extension XCTestCase {

    func chuteCaptureViewController(viewController: UIViewController, title: String) {
        UIApplication.shared.keyWindow!.rootViewController = viewController
        attachScreenshot(using: viewController.view, title: title)
        captureStyleSheetInfo(using: viewController.view, title: title)
    }

    func attachScreenshot(using: UIView, title: String) {

        UIGraphicsBeginImageContextWithOptions(using.bounds.size, using.isOpaque, 0)
        using.drawHierarchy(in: using.bounds, afterScreenUpdates: true)
        let snapshotImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        let attachment = XCTAttachment(image: snapshotImage)
        attachment.name = title
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func captureStyleSheetInfo(using rootView: UIView, title: String) {

        let style: [StyleSheet] = styleSheet(from: rootView, path: "")

        let encoder = JSONEncoder()
        if let data = try? encoder.encode(style) {
            let attachment = XCTAttachment(data: data, uniformTypeIdentifier: "chute.styleSheet")
            attachment.name = title
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }

    func styleSheet(from: UIView, path: String) -> [StyleSheet] {

        var styles: [StyleSheet] = [StyleSheet]()

        let identifier: String = {
            if let accessibilityIdentifier = from.accessibilityIdentifier {
                return accessibilityIdentifier
            } else {
                return String(describing: type(of: from))
            }
        }()

        styles.append(StyleSheet(identifier: identifier, path: path, view: from))

        for subview in from.subviews {
            let subviewStyle = styleSheet(from: subview, path: path == "" ? identifier : path + ":" + identifier)
            styles += subviewStyle
        }

        return styles
    }
}
