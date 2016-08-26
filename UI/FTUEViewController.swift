//
//  Created by Istvan Szekely on 26/08/16.
//  Copyright © 2016 iQuest Technologies. All rights reserved.
//

import UIKit

class FTUEViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var userTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if textField.text?.characters.count > 0 {
            okBtn.enabled = true
        } else {
            okBtn.enabled = false
        }
        return true
    }
    
    @IBAction func didTapOK(sender: AnyObject) {
        if let userID = userTextField.text {

            let user = User(withID: userID)
            user.save()

            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.networkClient = PeerToPeerNetworkClient(withUser: user)
            appDelegate.networkClient.setDelegate(appDelegate)

//            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(10 * Double(NSEC_PER_SEC)))
//            dispatch_after(delayTime, dispatch_get_main_queue()) {
//
//                let message = "Hi there!".dataUsingEncoding(NSUTF8StringEncoding)!
//                appDelegate.networkClient.sendMessage(message, to: "Alpar", completion: { (error) in
//                    print("Sent message with error: \(error)")
//                })
//            }
        }
    }
}
