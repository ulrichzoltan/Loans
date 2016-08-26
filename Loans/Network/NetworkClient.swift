//
//  NetworkClient.swift
//  Loans
//
//  Created by Zoltan Ulrich on 26.08.2016.
//  Copyright © 2016 iQuest Technologies. All rights reserved.
//

import Foundation

protocol NetworkClientDelegate: class {

    func didReceive(data: NSData, from: String)
}

protocol NetworkClient {

    init(withUser user: User)
    func sendMessage(message: NSData, to destinationID: String, completion: (error: NSError?) -> ())
    func setDelegate(delegate: NetworkClientDelegate)
}
