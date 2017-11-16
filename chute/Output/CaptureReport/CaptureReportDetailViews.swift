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
        <style>
        .gallery {
             -webkit-column-count: 3; /* Chrome, Safari, Opera */
             -moz-column-count: 3; /* Firefox */
             column-count: 3;
        }
        .gallery img{ width: 100%; padding: 7px 0; margin-bottom: 7px; }
        @media (max-width: 500px) {
            .gallery {
                -webkit-column-count: 1; /* Chrome, Safari, Opera */
                -moz-column-count: 1; /* Firefox */
                column-count: 1;
            }
        }
        .gallery-image {
            border: 1px solid lightgray;
            margin-bottom: 7px;
            border-radius: 5px;
            width: 100%;
            height: auto;
            display: inline-block;
        }
        .gallery-image > h5 {
            color: #777;
            padding: 7px 5px 0px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            border-bottom: 1px solid lightgray;
        }
        </style>
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
        for attachment in dataCapture.attachments {
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
