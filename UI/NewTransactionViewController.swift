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
            print("Gave")
        } else {
            print("Received")
        }
    }
    
    func createTransaction() {
        let transaction = Transaction(withUserId: nameTextField.text!
, andAmount: Int(amountTextField.text!)!, onDate: NSTimeInterval(), withMessage: detailsTextField.text!)

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
