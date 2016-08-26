//
//  TransactionService.swift
//  Loans
//
//  Created by Zoltan Ulrich on 26.08.2016.
//  Copyright © 2016 iQuest Technologies. All rights reserved.
//

import Foundation

protocol TransactionServiceDelegate: class {

    func didReceive(transaction transaction: Transaction)
    func didReceive(response response: Response)
}

class TransactionService {

    private let networkClient: NetworkClient
    weak var delegate: TransactionServiceDelegate?

    init(withUser user: User) {

        networkClient = PeerToPeerNetworkClient(withUser: user)
        networkClient.setDelegate(self)
    }

    func send(request: Request, completion: (error: NSError) -> ()) {

        networkClient.openConnection(request.recipientId) { error in

            if let error = error {
                completion(error: error)
            } else {

                let message = "{" +
                    "   \"transaction\": {" +
                    "       \"userId\": \"\(request.transaction.userId)\"," +
                    "       \"amount\": \(request.transaction.amount)," +
                    "       \"date\": \(request.transaction.date)," +
                    "       \"message\": \"\(request.transaction.message)\"" +
                    "   }" +
                "}"

                self.networkClient.sendMessage(message.dataUsingEncoding(NSUTF8StringEncoding)!,
                                               to: request.recipientId) { error in
                    print("Successfully sent request to: \(request.recipientId)")
                }
            }
        }
    }

    func send(response: Response, completion: (error: NSError) -> ()) {

        let message = "{" +
            " \"recepientId\": \"\(response.recipientId)\"" +
            " \"success\": \(response.success)," +
            " \"message\": \"\(response.message)\"" +
        "}"
        
        networkClient.sendMessage(message.dataUsingEncoding(NSUTF8StringEncoding)!,
                                  to: response.recipientId) { error in

            print("Successfully sent response to: \(response.recipientId)")
        }
    }
}

extension TransactionService: NetworkClientDelegate {

    func didReceive(data: NSData, from: String) {

        do {
            let dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: [])

            if let transaction = dictionary["transaction"] as? [String: AnyObject] {

                if let userId = transaction["userId"] as? String,
                    amount = transaction["amount"] as? Int,
                    date = transaction["date"] as? NSTimeInterval,
                    message = transaction["message"] as? String {

                    let transaction = Transaction(withUserId: userId, andAmount: amount, onDate: date, withMessage: message)
                    self.delegate?.didReceive(transaction: transaction)

                } else {
                    print("ERROR: Received incomplete transaction: \(transaction)")
                }

            } else if let recipientId = dictionary["recipientId"] as? String,
                          success = dictionary["success"] as? Bool,
                          message = dictionary["message"] as? String {

                let response = Response(recipientId: recipientId, success: success, message: message)
                print("INFO: Did receive response from: \(recipientId) with success: \(success) and message: \(message)")

                self.delegate?.didReceive(response: response)
                networkClient.closeConnection(recipientId)

            } else {
                print("ERROR: Received unrecognized data: \(dictionary)")
            }
        } catch {
            print("ERROR: Could not deserialize data: \(String(data: data, encoding: NSUTF8StringEncoding)) as JSON")
        }
    }
}

