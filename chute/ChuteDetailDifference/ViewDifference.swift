//
//  ViewDifference.swift
//  chute
//
//  Created by David House on 11/12/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct ViewDifference {
    
    let newViews: [ChuteTestAttachment]
    let changedViews: [(ChuteTestAttachment, ChuteTestAttachment)]
    
    init(detail: ChuteDetail, comparedTo: ChuteDetail, detailAttachmentURL: URL, comparedToAttachmentURL: URL) {
 
        var newViews = [ChuteTestAttachment]()
        var changedViews = [(ChuteTestAttachment, ChuteTestAttachment)]()
        
        for attachment in comparedTo.attachments {
            
            let found = detail.attachments.filter { $0.testIdentifier == attachment.testIdentifier && $0.attachmentName == attachment.attachmentName }
            if let foundAttachment = found.first {
                let originFileURL = detailAttachmentURL.appendingPathComponent(foundAttachment.attachmentFileName)
                let comparedToFileURL = comparedToAttachmentURL.appendingPathComponent(attachment.attachmentFileName)
                
                if let originData = try? Data(contentsOf: originFileURL), let comparedToData = try? Data(contentsOf: comparedToFileURL) {
                    
                    if originData != comparedToData {
                        changedViews.append((attachment, foundAttachment))
                    }
                }
            } else {
                newViews.append(attachment)
            }
        }
        
        self.newViews = newViews
        self.changedViews = changedViews
    }
}
