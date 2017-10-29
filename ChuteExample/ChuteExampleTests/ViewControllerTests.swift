//
//  ChuteExampleTests.swift
//  ChuteExampleTests
//
//  Created by David House on 10/21/17.
//  Copyright © 2017 David House. All rights reserved.
//

import XCTest
@testable import ChuteExample

class ViewControllerTests: XCTestCase {
    
    var viewController: ViewController!

    override func setUp() {
        let bundle = Bundle(for: ViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        guard let vc = storyboard.instantiateInitialViewController() as? ViewController else {
            XCTFail("Unable to instantiate the View Controller")
            return
        }
        viewController = vc
    }

    func testViewControllerCanBeInstantiated() {
        chuteCaptureViewController(viewController: viewController, title: "ViewControllerWithoutConfigure")
    }

    func testViewControllerWithNoDetails() {

        viewController.configure(header: "The Header", details: nil)
        chuteCaptureViewController(viewController: viewController, title: "ViewControllerWithNoDetails")
    }

    // Original tests

//    func testViewControllerWithFullConfigure() {
//
//        viewController.configure(header: "The Header", details: ["detail1", "detail2", "detail3"])
//        chuteCaptureViewController(viewController: viewController, title: "ViewControllerWithFullConfigure")
//    }
//
//    func testViewControllerWithOneDetail() {
//
//        viewController.configure(header: "The Header", details: ["detail1 only"])
//        chuteCaptureViewController(viewController: viewController, title: "ViewControllerWithFirstDetailOnly")
//    }
//
//    func testViewControllerWithTwoDetails() {
//
//        viewController.configure(header: "The Header", details: ["detail1", "detail2"])
//        chuteCaptureViewController(viewController: viewController, title: "ViewControllerWithTwoDetails")
//    }
//
//    func testOneTestFailsForReporting() {
//        XCTFail("Nothing to see here, move along")
//    }

    // Compared to tests
    //
    // We are removing one test, adding a new test and changing the status of one test so our comparison
    // report can be tested.

    // Changed Test result from failed to success
    func testOneTestFailsForReporting() {
    }

    // Brand new test with success
    func testOneMoreAdditionalTest() {

    }

    // Test result with an attachment that has changed
    func testViewControllerWithOneDetail() {

        viewController.configure(header: "The Header", details: ["detail1 changed"])
        chuteCaptureViewController(viewController: viewController, title: "ViewControllerWithFirstDetailOnly")
    }

    // Brand new test with attachment
    func testViewControllerWithNewDetailsTest() {

        viewController.configure(header: "The Header", details: ["detail1", "detail2"])
        chuteCaptureViewController(viewController: viewController, title: "ViewControllerWithNewDetails")
    }

    // Test with same status, but a new attachment!
    func testViewControllerWithFullConfigure() {

        viewController.configure(header: "The Header", details: ["detail1", "detail2", "detail3"])
        chuteCaptureViewController(viewController: viewController, title: "ViewControllerWithFullConfigure")
        attachScreenshot(using: viewController.view, title: "ViewControllerWithFullConfigureNewScreenshot")
    }
}
