//
//  AppDelegate.swift
//  Instagram
//
//  Created by coderdream on 2018/12/1.
//  Copyright © 2018 coderdream. All rights reserved.
//

import UIKit
import LeanCloud

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        LeanCloud.initialize(applicationID: "RMIdHYXjwJjQVMzm60Otf2oe-9Nh9j0Va", applicationKey: "VIVz2iX96UUnoy3TLANmeqN3")
        
        
        // AVAnalytics.trackAppOpened(launchOptions: launchOptions)
        
//        let testObject = AVObject(className: "TestObject")
//        testObject?.setObject("bar", forKey: "foo")
//       // testObject?.["foo"] = "bar"
//        testObject?.save()
//
//        /* Create an object. */
//        let object = LCObject()
//        object.set("words", value: "Hello World!")
////                let post = LCObject(className: "Post")
////
////                post.set("words", value: "Hello World!")
////
//
//        /* Save the object to LeanCloud application. */
//        object.save { result in
//            switch result {
//            case .success: print("Success")
//            case .failure: print("Failure")
//            }
//        }
//
////        let post = LCObject(className: "Post")
////
////        post.set("words", value: "Hello World!")
////
////        _ = post.save { result in
////            switch result {
////            case .success:
////                break
////            case .failure(let error):
////                break
////            }
////        }
        
//        let post = LCObject(className: "Post")
//
//        post.set("words", value: "Hello World!")
//
//        _ = post.save { result in
//            switch result {
//            case .success:
//                break
//            case .failure(let error):
//                break
//            }
//        }
        
        /* Create an object. */
        let object = LCObject(className: "Post")
        object.set("words", value: "Hello World!")
        /* Save the object to LeanCloud application. */
        object.save { result in
            switch result {
            case .success: print("Success")
            case .failure: print("Failure")
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

