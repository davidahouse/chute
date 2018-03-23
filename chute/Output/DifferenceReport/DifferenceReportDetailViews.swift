//
//  DifferenceReportDetailViews.swift
//  chute
//
//  Created by David House on 11/16/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

struct DifferenceReportDetailViews: ChuteOutputDifferenceRenderable {
    
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
                margin-bottom: 17px;
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
            .compare-gallery {
                -webkit-column-count: 2; /* Chrome, Safari, Opera */
                -moz-column-count: 2; /* Firefox */
                column-count: 2;
            }
            .compare-gallery img{ width: 100%; padding: 7px 0; margin-bottom: 7px; }
            </style>
            <div class="jumbotron">
            <h1>View Difference Details</h1>

            <h3>New Views:</h3>
            <div class="gallery">
            {{new_views}}
            </div>

            <h3>Changed Views:</h3>
            {{changed_views}}
            </div>
            """
    
            static let TestAttachmentTemplate = """
            <div class="gallery-image">
                <h5>{{attachment_name}}</h5>
                <img src="attachments/{{attachment_file_name}}" alt="{{attachment_name}}">
            </div>
            """
    
            static let TestCompareAttachmentTemplate = """
            <div class="compare-gallery">
                <div class="gallery-image">
                    <h5>BEFORE {{attachment_name}}</h5>
                    <img src="attachments/{{before_attachment_file_name}}" alt="{{attachment_name}}">
                </div>
                <div class="gallery-image">
                    <h5>AFTER {{attachment_name}}</h5>
                    <img src="attachments/{{attachment_file_name}}" alt="{{attachment_name}}">
                </div>
            </div>
            """
        }

    
    func render(difference: DataCaptureDifference) -> String {
        
        let parameters: [String: CustomStringConvertible] = [
            "new_views": newViews(difference: difference),
            "changed_views": changedViews(difference: difference)
        ]
        return Constants.Template.render(parameters: parameters)
    }

    private func newViews(difference: DataCaptureDifference) -> String {
        var views = ""
        for attachment in difference.viewDifference.newViews.sortedByName() {
            let attachmentParameters: [String: CustomStringConvertible] = [
                "attachment_name": attachment.attachmentName,
                "attachment_file_name": attachment.attachmentFileName
            ]
            views += Constants.TestAttachmentTemplate.render(parameters: attachmentParameters)
        }
        return views
    }

    private func changedViews(difference: DataCaptureDifference) -> String {
        var views = ""
        for (attachment, beforeAttachment) in difference.viewDifference.changedViews {
            let attachmentParameters: [String: CustomStringConvertible] = [
                "attachment_name": attachment.attachmentName,
                "before_attachment_file_name": "before_" + beforeAttachment.attachmentFileName,
                "attachment_file_name": attachment.attachmentFileName
            ]
            views += Constants.TestCompareAttachmentTemplate.render(parameters: attachmentParameters)
        }
        return views
    }

}
