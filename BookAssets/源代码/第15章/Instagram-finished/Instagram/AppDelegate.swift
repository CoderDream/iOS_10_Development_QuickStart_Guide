//
//  AppDelegate.swift
//  Instagram
//
//  Created by 刘铭 on 16/6/23.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    AVOSCloud.setApplicationId("2NL5pkgYfnrMXkbf17w5rU62-gzGzoHsz",
                               clientKey: "6Sl5rQaIyXh90CE0i26b2gaJ")

    // 如果想跟踪统计应用的打开情况，可以添加下面一行代码
    AVAnalytics.trackAppOpened(launchOptions: launchOptions)
    
//    let testObject = AVObject(className: "TestObject")
//    testObject?.setObject("bar", forKey: "foo")
//    testObject?.save()
    login()
    
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
  
  func login() {
    // 获取UserDefaults中存储的Key为username的值
    let username: String? = UserDefaults.standard.string(forKey: "username")
    
    // 如果之前成功登陆过
    if username != nil {
      let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let myTabBar = storyboard.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
      window?.rootViewController = myTabBar
 
      /*
      AVUser.current().follow("57720a1e1532bc005f098233") { (success:Bool, error:NSError?) in
        if success {
          print("为当前用户添加关注者成功！")
        }else {
          print("为当前用户添加关注者失败！")
        }
      }*/
    }
  }
}

