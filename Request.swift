//
//  Request.swift
//  Loans
//
//  Created by alpar on 26/08/16.
//  Copyright © 2016 iQuest Technologies. All rights reserved.
//

import Foundation

class Request: NSObject {
    
    let recipientId: String
    let transaction: Transaction
    
    init(withRecipientId recipientId: String,
                         andTransaction transaction: Transaction)
    {
        self.recipientId = recipientId
        self.transaction = transaction
        
        super.init()
    }
}




