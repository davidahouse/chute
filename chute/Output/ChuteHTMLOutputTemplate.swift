//
//  ChuteHTMLOutputTemplate.swift
//  chute
//
//  Created by David House on 10/20/17.
//  Copyright © 2017 David House. All rights reserved.
//

import Foundation

enum ChuteHTMLOutputTemplateConstants {

    static let Template: String = """
        <!DOCTYPE html>
        <html lang="en">
            <head>
            <meta charset="utf-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>{{title}}</title>

            <!-- Bootstrap -->
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">

            <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
            <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
            <!--[if lt IE 9]>
              <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
              <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
            <![endif]-->
            </head>
            <body>
            <style>
                .summary {
                     -webkit-column-count: 3; /* Chrome, Safari, Opera */
                     -moz-column-count: 3; /* Firefox */
                     column-count: 3;
                }
                .summary-2-column {
                     -webkit-column-count: 2; /* Chrome, Safari, Opera */
                     -moz-column-count: 2; /* Firefox */
                     column-count: 2;
                }
                .summary-1-column {
                     -webkit-column-count: 1; /* Chrome, Safari, Opera */
                     -moz-column-count: 1; /* Firefox */
                     column-count: 1;
                }
                .summary-iten {
                     -webkit-column-count: 1; /* Chrome, Safari, Opera */
                     -moz-column-count: 1; /* Firefox */
                     column-count: 1;
                    text-align: center;
                    padding: 7px 7px;
                }
                .summary-item-text {
                    text-align: center;
                }
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
            <div class="container">
            {{report}}
            </div>
            <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
            <!-- Include all compiled plugins (below), or include individual files as needed -->
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>
            </body>
        </html>
    """
}
