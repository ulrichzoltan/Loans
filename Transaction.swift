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
        static let amount = "amount"
        static let date = "date"
        static let description = "description"
    }
    
    let userId: String
    let amount: Int
    let date: NSTimeInterval
    let description: String
    
    init(withUserId userId: String,
                    amount amount: Int,
                          date date: NSTimeInterval,
                               description description: String) {
        
        self.userId = userId
        self.amount = amount
        self.date = date
        self.description = description
        
        super.init()
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        
        userId = aDecoder.decodeObjectForKey(Keys.userId) as! String
        amount = aDecoder.decodeObjectForKey(Keys.amount) as! Int
        date = aDecoder.decodeObjectForKey(Keys.date) as! NSTimeInterval
        description = aDecoder.decodeObjectForKey(Keys.description) as! String
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(userId, forKey: Keys.userId)
        aCoder.encodeObject(amount, forKey: Keys.amount)
        aCoder.encodeObject(date, forKey: Keys.date)
        aCoder.encodeObject(description, forKey: Keys.description)
    }
}

