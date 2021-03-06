//
//  Created by Istvan Szekely on 26/08/16.
//  Copyright © 2016 iQuest Technologies. All rights reserved.
//

import UIKit

class NewTransactionViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var okBtn: UIButton!
    var name: String?
    let user: User

    var pendingTransaction: Transaction? = nil
    var transactionPartner: String? = nil

    let transactionService: TransactionService

    required init?(coder aDecoder: NSCoder) {

        user = User.savedUser()!
        transactionService = TransactionService(withUser: user)

        super.init(coder: aDecoder)

        transactionService.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScreen()

        // Do any additional setup after loading the view.
    }

    func setupScreen() {

        if let name = name {
            nameTextField.hidden = true
            nameLbl.hidden = false
            nameLbl.text = name
        } else {
            nameTextField.hidden = false
            nameLbl.hidden = true
        }
    }
    
    @IBAction func didTapOK(sender: AnyObject) {

        if segmentedControl.selectedSegmentIndex == 0 {

            pendingTransaction = Transaction(withUserId: user.id,
                                          andAmount: Int(amountTextField.text!)!,
                                          onDate: NSDate().timeIntervalSince1970,
                                          withMessage: detailsTextField.text!)
        } else {
            pendingTransaction = Transaction(withUserId: user.id,
                                      andAmount: -Int(amountTextField.text!)!,
                                      onDate: NSDate().timeIntervalSince1970,
                                      withMessage: detailsTextField.text!)
        }

        transactionPartner = nameTextField.text!

        let request = Request(recipientId: transactionPartner!, transaction: pendingTransaction!)
        transactionService.send(request) { error in
            print("Sent request to: \(self.transactionPartner!) with error: \(error)")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        okBtn.enabled = false

        if name == nil {
            if (nameTextField.text?.characters.count > 0) && (amountTextField.text?.characters.count > 0) && (detailsTextField.text?.characters.count > 0) {
                okBtn.enabled = true
            }
        } else {
            if (amountTextField.text?.characters.count > 0) && (detailsTextField.text?.characters.count > 0) {
                okBtn.enabled = true
            }
        }

        return true
    }
}

extension NewTransactionViewController: TransactionServiceDelegate {

    func didReceive(transaction transaction: Transaction) {

        print("Received transaction: \(transaction)")

//        let response = Response(success: true, message: "Thanks for the loan.")
//
//        transactionService.send(response, to: transaction.userId) { error in
//            print("Sent response.")
//        }
    }

    func didReceive(response response: Response) {

        print("Received response: \(response)")

        if response.success {
            pendingTransaction?.userId = transactionPartner!
            appDelegate?.loans?.update(pendingTransaction!)
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                let action = UIAlertController(title: "Rejected", message: "\(self.transactionPartner!) refused the transaction", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { alertAction in
                })
                action.addAction(defaultAction)
                self.presentViewController(action, animated: true, completion: nil)
            }
        }

        dispatch_async(dispatch_get_main_queue()) { 
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
