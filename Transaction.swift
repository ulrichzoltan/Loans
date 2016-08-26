//
//  Transaction.swift
//  Loans
//
//  Created by alpar on 26/08/16.
//  Copyright © 2016 iQuest Technologies. All rights reserved.
//

import Foundation

class Transaction: NSObject, NSCoding {
    
    private struct Keys {
        static let userId = "userId"
        static let transaction = "transaction"
    }
    
    let userId: String
    let value: Int
    let date: NSTimeInterval
    let description: String
    
    init(withUserId userId: String,
                    value value: Int,
                          date date: NSTimeInterval,
                               description description: String) {
        
        self.userId = userId
        self.value = value
        self.date = date
        self.description = description
        
        super.init()
    }
    
//    class func savedTransaction() -> Transaction? {
//        
//        return NSUserDefaults.standardUserDefaults().objectForKey(Keys.transaction) as? Transaction
//    }
//    
//    func save() {
//        
//        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
//        NSUserDefaults.standardUserDefaults().setObject(data, forKey: Keys.transaction)
//        NSUserDefaults.standardUserDefaults().synchronize()
//    }
//    
//    @objc required init?(coder aDecoder: NSCoder) {
//        
//        // I know of no way we can make a decoder provide invalid input
//        // in order to test the failure case.
//        
//        id = aDecoder.decodeObjectForKey(Keys.userId) as! String
//    }
//    
//    @objc func encodeWithCoder(aCoder: NSCoder) {
//        
//        aCoder.encodeObject(userId, forKey: Keys.userId)
//    }
}

