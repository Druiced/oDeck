//
//  AppDelegate.swift
//  oDeck
//
//  Created by Andrew on 5/21/15.
//  Copyright (c) 2015 Andrew Douwes. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.322, green: 0.459, blue: 0.702, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()

        // Pulling Parse.Com Keys from Keys.plist file so they aren't stored on GitHub
        let path = NSBundle.mainBundle().pathForResource("Keys", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let setApplicationId: AnyObject = dict!.objectForKey("setApplicationId")!
        let clientKey: AnyObject = dict!.objectForKey("clientKey")!
        
        Parse.enableLocalDatastore()
        // Initialize Parse.
        Parse.setApplicationId(setApplicationId as! String, clientKey: clientKey as! String)
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        //trackAppOpenedWithLaunchOptions(launchOptions) //this is what parse said to use, it didnt work.

        
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


}

