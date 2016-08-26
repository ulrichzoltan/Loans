//
//  DetailViewController.swift
//  Loans
//
//  Created by Zoltan Ulrich on 25.08.2016.
//  Copyright © 2016 iQuest Technologies. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    @IBAction func publish(sender: AnyObject) {

        let client = (UIApplication.sharedApplication().delegate as! AppDelegate).pubNubClient
        client.publish("Hello from the PubNub Swift SDK",
                        toChannel: "zoli",
                        compressed: false,
                        completion: { publishStatus in

            if !publishStatus.error {

                // Message successfully published to specified channel.
            }
            else {

                /**
                 Handle message publish error. Check 'category' property to find out
                 possible reason because of which request did fail.
                 Review 'errorData' property (which has PNErrorData data type) of status
                 object to get additional information about issue.

                 Request can be resent using: publishStatus.retry()
                 */
            }
        })
    }
}

