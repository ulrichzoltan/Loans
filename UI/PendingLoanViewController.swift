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

        setupQuestionLabel()
    }
    
    func setupQuestionLabel() {
        questionLbl.text = "Did \(transaction?.userId) lend you \(transaction?.amount) RON for \(transaction?.message)?"
    }

    @IBAction func didTapOK(sender: AnyObject) {
        
    }

    @IBAction func didTapNotOK(sender: AnyObject) {
        
    }

}
