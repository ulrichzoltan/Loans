//
//  Created by Istvan Szekely on 26/08/16.
//  Copyright © 2016 iQuest Technologies. All rights reserved.
//

import UIKit

class BuddyListViewController: UIViewController {

    @IBOutlet weak var buddyTableView: UITableView!

    required init?(coder aDecoder: NSCoder) {

        transactionService = TransactionService(withUser: user!)

        super.init(coder: aDecoder)

        transactionService!.delegate = self
    }
    

    override func viewDidLoad() {

        super.viewDidLoad()
    }
}

extension BuddyListViewController: TransactionServiceDelegate {

    func didReceive(transaction transaction: Transaction) {

        print("Received transaction: \(transaction)")
        let response = Response(success: true, message: "Thanks for the loan.")

        transaction.amount = -transaction.amount
        appDelegate?.loans?.update(transaction)

        transactionService!.send(response, to: transaction.userId) { error in
            print("Sent response.")
        }
    }

    func didReceive(response response: Response) {
    }
}
