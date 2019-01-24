//
//  SignInVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/6/23.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

class SignInVC: UIViewController {
  
  @IBOutlet weak var usernameTxt: UITextField!
  @IBOutlet weak var passwordTxt: UITextField!
  
  @IBOutlet weak var signInBtn: UIButton!
  @IBOutlet weak var signUpBtn: UIButton!
  @IBOutlet weak var forgotBtn: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  // 点击登陆按钮
  @IBAction func signInBtn_click(_ sender: UIButton) {
    print("登陆按钮被点击")
    
    // 隐藏键盘
    self.view.endEditing(true)
    
    if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
      let alert = UIAlertController(title: "请注意", message: "请填写好所有的字段", preferredStyle: .alert)
      let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alert.addAction(ok)
      self.present(alert, animated: true, completion: nil)
    }
    
    // 实现用户登录功能
    AVUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) { (user:AVUser?, error:NSError?) in
      if error == nil {
        // 记住用户
        UserDefaults.standard().set(user!.username, forKey: "username")
        UserDefaults.standard().synchronize()
        
        // 调用AppDelegate类的login方法
        let appDelegate: AppDelegate = UIApplication.shared().delegate as! AppDelegate
        appDelegate.login()
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
