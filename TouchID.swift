//
//  TouchID.swift
//  Loans
//
//  Created by Zoltan Ulrich on 26.08.2016.
//  Copyright © 2016 iQuest Technologies. All rights reserved.
//

import Foundation
import LocalAuthentication

protocol FingerprintScanner {

    var isUserEnrolled: Bool {get}
    func scanFinger(reason: String, fallbackEnabled: Bool, callback: LAError? -> Void)

}

final class TouchID: FingerprintScanner {

    static var sharedInstance: FingerprintScanner = TouchID()

    private let policy = LAPolicy.DeviceOwnerAuthenticationWithBiometrics
    private init() {}

    var isUserEnrolled: Bool {
        return LAContext().canEvaluatePolicy(policy, error: nil)
    }

    func scanFinger(reason: String, fallbackEnabled: Bool, callback: LAError? -> Void) {

        let context = LAContext()
        context.localizedFallbackTitle = fallbackEnabled ? nil : ""

        print("Displaying OS Touch ID authentication with reason '\(reason)'")
        context.evaluatePolicy(policy, localizedReason: reason) { _, error in
            callback(error as? LAError)
        }
    }
}
