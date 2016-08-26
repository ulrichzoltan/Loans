//
//  Response.swift
//  Loans
//
//  Created by alpar on 26/08/16.
//  Copyright © 2016 iQuest Technologies. All rights reserved.
//

import Foundation

class Response: NSObject {
    
    let success: BOOL
    let message: String
    
    init(withSuccess success: BOOL,
                     message message: String)
    {
        self.success = success
        self.message = message
        
        super.init()
    }
}
