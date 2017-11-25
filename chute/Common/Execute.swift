//
//  Execute.swift
//  chute
//
//  Created by David House on 11/24/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

class Execute {
    
    static func shell(command: [String]) -> String? {
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = command
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String? = String(data: data, encoding: String.Encoding.utf8)
        
        return output
    }
}
