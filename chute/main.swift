//
//  main.swift
//  chute
//
//  Created by David House on 9/3/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

func printOut(_ message: String, with: Printable? = nil) {
    print("---")
    print(message)
    with?.printOut()
    print("---")
    print("")
}

printOut("chute: 1.0.1")

let arguments = CommandLineArguments()
printOut("Arguments:", with: arguments)

// Required parameters
guard arguments.hasRequiredParameters, let project = arguments.project else {
    arguments.printInstructions()
    exit(1)
}

// Environment
let environment = Environment(arguments: arguments)
printOut("Environment:", with: environment)
guard environment.hasValidEnvironment else {
    exit(1)
}

// Capture data using the environment
printOut("Capturing data")
guard let dataCapture = DataCapture(using: environment) else {
    print("Error capturing data")
    exit(1)
}

// Capture saved data from compareTo folder (if specified)
let comparedToDataCapture = DataCapture(using: environment, from: arguments.compareFolder)
var difference: DataCaptureDifference?
if let comparedTo = comparedToDataCapture {
    printOut("Comparing data captures")
    difference = DataCaptureDifference(detail: comparedTo, comparedTo: dataCapture)
}

// Prepare the output folder
printOut("Saving source data to output folder")
let outputFolder = ChuteOutputFolder()
outputFolder.empty()
outputFolder.populate(using: environment, including: dataCapture, and: difference)

// Create reports
printOut("Creating reports")
let output = ChuteOutput(into: outputFolder)
output.createReports(with: dataCapture, and: difference)

// Publish reports
printOut("Publishing reports")
let publisher = Publisher(environment: environment, outputFolder: outputFolder, testExecutionDate: dataCapture.testExecutionDate)
publisher.publish()

// Send notifications
printOut("Sending notifications")
let notifier = Notifier(environment: environment, dataCapture: dataCapture, difference: difference)
notifier.notify()

// If save set, save the gathered data
printOut("Chute finished.")
