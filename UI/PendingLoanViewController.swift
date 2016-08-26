//
//  Created by Istvan Szekely on 26/08/16.
//  Copyright © 2016 iQuest Technologies. All rights reserved.
//

import UIKit

class PendingLoanViewController: UIViewController {

    @IBOutlet weak var questionLbl: UILabel!
    var transaction: Transaction?

    override func viewDidLoad() {

        super.viewDidLoad()

        questionLbl.text =
            "Did \(transaction!.userId) lend you \(transaction!.amount) RON for \(transaction!.message)?"
    }

    @IBAction func didTapOK(sender: AnyObject) {

        guard let transaction = transaction else {
            return
        }

        TouchID.sharedInstance.scanFinger(
            "Are you sure?",
            fallbackEnabled: false) { error in

            if let error = error {

                switch error {

                case .AuthenticationFailed, .UserFallback, .UserCancel, .SystemCancel, .AppCancel, .InvalidContext:
                    return
                case .PasscodeNotSet, .TouchIDNotAvailable, .TouchIDNotEnrolled:
                    break
                default:
                    return
                }
            } else {
                
                let response = Response(success: true, message: "Thanks for the loan.")

                transaction.amount = -transaction.amount
                appDelegate?.loans?.update(transaction)

                transactionService!.send(response, to: transaction.userId) { error in
                    print("Sent accept response.")
                }
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    @IBAction func didTapNotOK(sender: AnyObject) {

        defer {
            self.dismissViewControllerAnimated(true, completion: nil)
        }

        guard let transaction = transaction else {
            return
        }

        let response = Response(success: false, message: "No way!")

        transactionService!.send(response, to: transaction.userId) { error in
            print("Sent deny response.")
        }
    }
}
