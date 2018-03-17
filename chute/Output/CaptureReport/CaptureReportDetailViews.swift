//
//  CaptureReportDetailViews.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct CaptureReportDetailViews: ChuteOutputRenderable {
    
    enum Constants {
        static let Template = """
        <div class="jumbotron">
        <h3>View Captures</h3>
        <div class="gallery">
        {{screenshots}}
        </div>
        </div>
        """

        static let TestAttachmentTemplate = """
        <div class="gallery-image">
            <h5>{{attachment_name}}</h5>
            <img src="attachments/{{attachment_file_name}}" alt="{{attachment_name}}">
            <div class="clearfix"></div>
        </div>
        """
    }
    
    func render(dataCapture: DataCapture) -> String {
        
        var screenshots = ""
        for attachment in dataCapture.attachments.sortedByName() {
            let attachmentParameters: [String: CustomStringConvertible] = [
                "attachment_name": attachment.attachmentName,
                "attachment_file_name": attachment.attachmentFileName
            ]
            screenshots += Constants.TestAttachmentTemplate.render(parameters: attachmentParameters)
        }

        let parameters: [String: CustomStringConvertible] = [
            "screenshots": screenshots
        ]
        return Constants.Template.render(parameters: parameters)
    }
}
