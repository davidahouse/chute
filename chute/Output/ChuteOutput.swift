//
//  ChuteOutput.swift
//  chute
//
//  Created by David House on 10/20/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

protocol HTMLRenderable {
    func renderSummary() -> String
    func renderDetail() -> String
}

protocol ChuteOutputRenderable {
    func render(dataCapture: DataCapture) -> String
}

protocol ChuteOutputDifferenceRenderable {
    func render(difference: DataCaptureDifference) -> String
}

class ChuteOutput {

    let outputFolder: ChuteOutputFolder

    init(into outputFolder: ChuteOutputFolder) {
        self.outputFolder = outputFolder
    }

    func createReports(with dataCapture: DataCapture, and difference: DataCaptureDifference?) {
        
        let mainReport = CaptureReport()
        print("Creating chute.html")
        outputFolder.saveOutputFile(fileName: "chute.html", contents: mainReport.render(dataCapture: dataCapture))
        
        if let difference = difference {
            let differenceReport = DifferenceReport()
            print("Creating chute_difference.html")
            outputFolder.saveOutputFile(fileName: "chute_difference.html", contents: differenceReport.render(difference: difference))
        }
    }
}
