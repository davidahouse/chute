//
//  BuildFolder.swift
//  chute
//
//  Created by David House on 2/16/18.
//  Copyright © 2018 David House. All rights reserved.
//

import Foundation

class BuildFolder {
    
    let rootURL: URL
    
    init(projectFileURL: URL) {
        self.rootURL = projectFileURL.appendingPathComponent("build")
    }
}

extension BuildFolder: Printable {
    
    func printOut() {
        print("Build Folder URL: \(rootURL.path)")
    }
}
