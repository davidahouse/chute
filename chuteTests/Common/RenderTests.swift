//
//  RenderTests.swift
//  chuteTests
//
//  Created by David House on 10/20/17.
//  Copyright © 2017 David House. All rights reserved.
//

import XCTest
@testable import chute

class RenderTests: XCTestCase {

    func testRenderCanReplaceStringParameters() {

        let parameters: [String: CustomStringConvertible] = [
            "first": "Hello",
            "second": "World"
        ]

        let renders: [(String, String)] = [
            ("{{first}} {{second}}", "Hello World"),
            ("{{first}} {{first}} {{second}}", "Hello Hello World")
        ]

        for render in renders {
            XCTAssertEqual(render.0.render(parameters: parameters), render.1)
        }
    }

    func testRenderCanReplaceIntParameters() {

        let parameters: [String: CustomStringConvertible] = [
            "first": "Hello",
            "second": 123
        ]

        let renders: [(String, String)] = [
            ("{{first}} {{second}}", "Hello 123"),
            ("{{first}} {{first}} {{second}}", "Hello Hello 123")
        ]

        for render in renders {
            XCTAssertEqual(render.0.render(parameters: parameters), render.1)
        }
    }
}
