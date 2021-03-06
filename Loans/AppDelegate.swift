//
//  AppDelegate.swift
//  Loans
//
//  Created by Zoltan Ulrich on 25.08.2016.
//  Copyright © 2016 iQuest Technologies. All rights reserved.
//

import UIKit
import PubNub
import IQKeyboardManagerSwift

var appDelegate: AppDelegate? = nil
var transactionService: TransactionService? = nil
var user: User? = nil

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var loans: Loans? = nil

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true
        application.statusBarHidden = true

        user = User.savedUser()
        appDelegate = self

        loans = Loans()
        loans?.load()

        if let _ = user {

            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let dashboardVC = storyboard.instantiateViewControllerWithIdentifier("dashboard")
            window?.rootViewController = dashboardVC
        }
//
//        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil))
//        application.registerForRemoteNotifications()

        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {

        print("Received notification with \(userInfo)")
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {

        print("Token: \(deviceToken.base64EncodedDataWithOptions([]))")

//        pubNubClient?.registerPushToken(deviceToken)
    }
}
