//
//  Created by Istvan Szekely on 26/08/16.
//  Copyright © 2016 iQuest Technologies. All rights reserved.
//

import UIKit

class BuddyListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var buddyTableView: UITableView!
    var buddyList = []
    required init?(coder aDecoder: NSCoder) {
        
        transactionService = TransactionService(withUser: user!)
        
        super.init(coder: aDecoder)
        
        transactionService!.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        buddyList = (appDelegate?.loans?.transactions)!
        buddyTableView.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buddyTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        buddyTableView.delegate = self
        buddyTableView.dataSource = self
        buddyList = (appDelegate?.loans?.transactions)!
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.buddyList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
        cell.textLabel?.text = (self.buddyList[indexPath.row] as! Transaction).userId
        cell.detailTextLabel?.text = String((self.buddyList[indexPath.row] as! Transaction).amount)
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}

extension BuddyListViewController: TransactionServiceDelegate {
    
    func didReceive(transaction transaction: Transaction) {
        
        print("Received transaction: \(transaction)")

        dispatch_async(dispatch_get_main_queue()) {
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let pendingVC = storyboard.instantiateViewControllerWithIdentifier("pending") as! PendingLoanViewController
            pendingVC.transaction = transaction

            self.navigationController?.presentViewController(pendingVC, animated: true, completion: nil)
        }
    }
    
    func didReceive(response response: Response) {
    }
}
