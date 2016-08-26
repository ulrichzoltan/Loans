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
        static let message = "message"
    }
    
    var userId: String
    var amount: Int
    var date: NSTimeInterval
    var message: String
    
    init(withUserId userId: String,
                    andAmount amount: Int,
                          onDate date: NSTimeInterval,
                               withMessage message: String) {
        
        self.userId = userId
        self.amount = amount
        self.date = date
        self.message = message
        
        super.init()
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        
        userId = aDecoder.decodeObjectForKey(Keys.userId) as! String
        amount = aDecoder.decodeObjectForKey(Keys.amount) as! Int
        date = aDecoder.decodeObjectForKey(Keys.date) as! NSTimeInterval
        message = aDecoder.decodeObjectForKey(Keys.message) as! String
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(userId, forKey: Keys.userId)
        aCoder.encodeObject(amount, forKey: Keys.amount)
        aCoder.encodeObject(date, forKey: Keys.date)
        aCoder.encodeObject(message, forKey: Keys.message)
    }
    
    func update(withAmount amount: Int,
                           andMessage message: String,
                                      onDate date: NSTimeInterval) {
        
        self.amount += amount
        self.message = message
        self.date = date
    }
}

