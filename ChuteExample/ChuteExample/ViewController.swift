//
//  ViewController.swift
//  ChuteExample
//
//  Created by David House on 10/21/17.
//  Copyright © 2017 David House. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet private var headerLabel: UILabel!
    @IBOutlet private var detailLabel: UILabel!
    @IBOutlet private var subDetailLabel: UILabel!
    @IBOutlet private var moreDetailLabel: UILabel!

    // MARK: Properties
    private var header: String?
    private var details: [String]?

    // MARK: Configure

    func configure(header: String, details: [String]?) {

        self.header = header
        self.details = details
    }

    // MARK: ViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        headerLabel.text = header
        if let details = details, details.count > 0 {

            if details.count == 3 {
                detailLabel.text = details[0]
                subDetailLabel.text = details[1]
                moreDetailLabel.text = details[2]
            } else if details.count == 2 {
                detailLabel.text = details[0]
                detailLabel.textColor = UIColor.blue
                subDetailLabel.text = details[1]
                subDetailLabel.textColor = UIColor.blue
                moreDetailLabel.text = ""

            } else if details.count == 1 {
                detailLabel.text = details[0]
                detailLabel.textColor = UIColor.red
                subDetailLabel.text = ""
                moreDetailLabel.text = ""
            }
        } else {
            detailLabel.text = ""
            subDetailLabel.text = ""
            moreDetailLabel.text = ""
        }
    }

    // This method just gives us a path that will not be executed so we can report
    // on code coverage differences.
    func untestedMethod() {
        self.view.backgroundColor = .black
    }
}
