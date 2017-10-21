//
//  ChuteTestAttachment.swift
//  chute
//
//  Created by David House on 10/14/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct ChuteTestAttachment: Encodable {

    let testIdentifier: String
    let attachmentName: String
    let attachmentFileName: String

    init?(testIdentifier: String, attachment: ActivityAttachment) {

        guard let name = attachment.name, let filename = attachment.filename else {
            return nil
        }

        if attachment.uti == "chute.styleSheet" {
            return nil
        }

        self.testIdentifier = testIdentifier
        attachmentName = name
        attachmentFileName = filename
    }
}
