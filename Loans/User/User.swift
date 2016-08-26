//
//  User.swift
//  
//
//  Created by Zoltan Ulrich on 26.08.2016.
//
//

import Foundation

class User: NSObject, NSCoding {

    private struct Keys {
        static let id = "id"
        static let displayName = "displayName"

        static let user = "user"
    }

    let id: String
    let displayName: String

    class func savedUser() -> User {

        return NSUserDefaults.standardUserDefaults().objectForKey(Keys.user) as User?
    }

    func save() {

        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: Keys.user)
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    @objc required init?(coder aDecoder: NSCoder) {

        // I know of no way we can make a decoder provide invalid input
        // in order to test the failure case.

        id = aDecoder.decodeObjectForKey(Keys.id) as! String
        displayName = aDecoder.decodeObjectForKey(Keys.displayName) as! String
    }

    @objc func encodeWithCoder(aCoder: NSCoder) {

        aCoder.encodeObject(id, forKey: Keys.id)
        aCoder.encodeObject(displayName, forKey: Keys.displayName)
    }
}
