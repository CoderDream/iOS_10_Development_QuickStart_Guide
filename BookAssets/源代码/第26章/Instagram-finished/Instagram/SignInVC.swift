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
  
  @IBOutlet weak var label: UILabel!
  
  @IBOutlet weak var usernameTxt: UITextField!
  @IBOutlet weak var passwordTxt: UITextField!
  
  @IBOutlet weak var signInBtn: UIButton!
  @IBOutlet weak var signUpBtn: UIButton!
  @IBOutlet weak var forgotBtn: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // label的字体设置
    label.font = UIFont(name: "Pacifico", size: 25)
    
    label.frame = CGRect(x: 10, y: 80, width: self.view.frame.width - 20, height: 50)
    
    usernameTxt.frame = CGRect(x: 10, y: label.frame.origin.y + 70, width: self.view.frame.width - 20, height: 30)
    passwordTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: self.view.frame.width - 20, height: 30)
    
    forgotBtn.frame = CGRect(x: 10, y: passwordTxt.frame.origin.y + 30, width: self.view.frame.width - 20, height: 30)
    signInBtn.frame = CGRect(x: 20, y: forgotBtn.frame.origin.y + 40, width: self.view.frame.width / 4, height: 30)
    signUpBtn.frame = CGRect(x: self.view.frame.width - signInBtn.frame.width - 20, y: signInBtn.frame.origin.y, width: signInBtn.frame.width, height: 30)
    
    let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    hideTap.numberOfTapsRequired = 1
    self.view.isUserInteractionEnabled = true
    self.view.addGestureRecognizer(hideTap)
    
    //设置背景图
    let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
    
    bg.image = UIImage(named: "bg.jpg")
    bg.layer.zPosition = -1
    self.view.addSubview(bg)
    
  }
  
  func hideKeyboard(recognizer: UITapGestureRecognizer) {
    self.view.endEditing(true)
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
      
      return
    }
    
    // 实现用户登录功能
    AVUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) { (user:AVUser?, error:Error?) in
      if error == nil {
        // 记住用户
        UserDefaults.standard.set(user!.username, forKey: "username")
        UserDefaults.standard.synchronize()
        
        // 调用AppDelegate类的login方法
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.login()
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}
