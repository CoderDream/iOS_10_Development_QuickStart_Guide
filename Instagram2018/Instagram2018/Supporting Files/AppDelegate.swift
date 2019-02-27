//
//  AppDelegate.swift
//  Instagram2018
//
//  Created by CoderDream on 2018/12/5.
//  Copyright © 2018 CoderDream. All rights reserved.
//

import UIKit
import LeanCloud

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func login() {
        // 获取 UserDefaults 中存储的 Key 为 username 的值
        let username: String? = UserDefaults.standard.string(forKey: "username")
        
        // 如果之前成功登录过
        if username != nil {
            print(username)
            print("之前成功登录过")
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let myTabBar = storyboard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
            window?.rootViewController = myTabBar
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        LCApplication.default.set(
            id:  "ERva8YPYgr5sPN6UJdWq5HuH-9Nh9j0Va", /* Your app ID */
            key: "3wnkDhfhLxv8QQQaXT4N9lWT" /* Your app key */
        )
       
        
        // login()
       // method1001_deleteObject()
       // saveImageFile()
        saveImagePngFile()
        return true
    }
    
    private func savePost() {
        let post = LCObject(className: "Post")
        
        do {
            try post.set("words", value: "Hello World!")
            
            _ = post.save { result in
                switch result {
                case .success: print("Success")
                case .failure(let error):
                    print("Failure")
                    print("出错了：\(error)")
                    break
                }
            }
        } catch {
        }
    }
    
    private func  saveImageFile() {
        if let url = Bundle.main.url(forResource: "1", withExtension: "jpg") {
            let file = LCFile(payload: .fileURL(fileURL: url))
            
            //上传进度监听
            //一般来说，上传文件都会有一个上传进度条显示用以提高用户体验：
            _ = file.save(
                progress: { progress in
                    print(progress)
            },
                completion: { result in
                    switch result {
                    case .success:
                        // handle success
                        print("LCFile upload success")
                        break
                    case .failure(error: let error):
                        // handle error
                        print(error)
                        break
                    }
            })
        }
    }
    
    private func saveImagePngFile() {
        if let url = Bundle.main.url(forResource: "PlayerWalk_0_00", withExtension: "png") {
            let file = LCFile(payload: .fileURL(fileURL: url))
            
            //上传进度监听
            //一般来说，上传文件都会有一个上传进度条显示用以提高用户体验：
            _ = file.save(
                progress: { progress in
                    print(progress)
            },
                completion: { result in
                    switch result {
                    case .success:
                        // handle success
                        print("LCFile upload success")
                        break
                    case .failure(error: let error):
                        // handle error
                        print(error)
                        break
                    }
            })
        }
    }
    
    private func  method1001_deleteObject() {
        let todo = LCObject(className: "Post", objectId: "5c4aa7a20c58ec001a7a60b6")
        
        // 调用实例方法删除对象
        _ = todo.delete { result in
            switch result {
            case .success:
                print("Todo Object delete success")
            break // 删除成功
            case .failure(let error):
                print(error)
            }
        }
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

