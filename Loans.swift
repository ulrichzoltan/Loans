//
//  Loans.swift
//  Loans
//
//  Created by alpar on 26/08/16.
//  Copyright © 2016 iQuest Technologies. All rights reserved.
//

import Foundation

class Loans: NSObject, NSCoding {
    
    private struct Keys {
        static let transactions = "transactions"
    }
    
    typealias TransactionList = [Transaction]
    
    var transactions: TransactionList
    
    init(withTransactions transactions: TransactionList) {
        
        self.transactions = transactions
        
        super.init()
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        
        transactions = aDecoder.decodeObjectForKey(Keys.transactions) as! TransactionList
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(transactions, forKey: Keys.transactions)
    }
}



