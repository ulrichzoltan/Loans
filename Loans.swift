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
    
    override init() {
        
        self.transactions = TransactionList()
        super.init()
    }
    
    init(withTransactions transactions: TransactionList) {
        
        self.transactions = transactions
        
        super.init()
        
        self.save()
        
    }
    
    // coding
    
    @objc required init?(coder aDecoder: NSCoder) {
        
        transactions = aDecoder.decodeObjectForKey(Keys.transactions) as! TransactionList
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(transactions, forKey: Keys.transactions)
    }
    
    // store
    
    func save(){
        
        let transactionsData = NSKeyedArchiver.archivedDataWithRootObject(transactions)
        NSUserDefaults.standardUserDefaults().setObject(transactionsData, forKey: Keys.transactions)
    }
    
    func load(){
        
        if let transactionsData = NSUserDefaults.standardUserDefaults().objectForKey(Keys.transactions) as? NSData {
            self.transactions = NSKeyedUnarchiver.unarchiveObjectWithData(transactionsData) as! TransactionList
        }
        else {
            self.transactions = TransactionList()
            self.save()
        }
    }
    
    // operations
    
    func remove(transaction: Transaction) {
        
        self.transactions = transactions.filter {
            return $0.userId != transaction.userId
        }
    }
    
    func update(transaction: Transaction) {
        
        let oldTransaction = transactions.filter {
            return $0.userId == transaction.userId
        }.first
        
        if oldTransaction == nil {
            
            transactions.append(transaction)
        }
        else {
            
            oldTransaction!.update(withAmount: transaction.amount,
                                   andMessage:transaction.message,
                                   onDate:transaction.date)
            
            if oldTransaction!.amount == 0 {
                
                remove(oldTransaction!)
            }
        }
    }
}



