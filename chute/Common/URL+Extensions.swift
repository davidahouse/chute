//
//  URL+Extensions.swift
//  chute
//
//  Created by David House on 10/14/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

extension URL {

    func appendingPathComponents(_ components: [String]) -> URL {

        if components.count > 0 {
            return self.appendingPathComponent(components.first!).appendingPathComponents(Array(components.dropFirst()))
        } else {
            return self
        }
    }
    
    func printOutFileTree() {
        
        guard self.isFileURL else {
            print("Not a file system URL")
            return
        }
        
        print("Contents of: \(self.path)")
        let enumerator = FileManager.default.enumerator(atPath: path)
        
        while let fileName = enumerator?.nextObject() as? String {
            print("\(fileName)")
        }
    }
}
