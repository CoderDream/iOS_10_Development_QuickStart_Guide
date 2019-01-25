//
//  SignInVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/6/23.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import LeanCloud

class SignInVC: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.frame = CGRect(x: 10, y: 80, width: self.view.frame.width - 20, height: 50)
        
        usernameTxt.frame = CGRect(x: 10, y: label.frame.origin.y + 70, width: self.view.frame.width - 20, height: 30)
        passwordTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: self.view.frame.width - 20, height: 30)
        
        forgotBtn.frame = CGRect(x: 10, y: passwordTxt.frame.origin.y + 30, width: self.view.frame.width - 20, height: 30)
        signInBtn.frame = CGRect(x: 20, y: forgotBtn.frame.origin.y + 40, width: self.view.frame.width / 4, height: 30)
        signUpBtn.frame = CGRect(x: self.view.frame.width - signInBtn.frame.width - 20, y: signInBtn.frame.origin.y, width: signInBtn.frame.width, height: 30)
        
    }
    
    // 隐藏视图中的虚拟键盘
    @objc
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
        }
        
        // 实现用户登录功能
        let result = LCUser.logIn(username: usernameTxt.text!, password: passwordTxt.text!)
        
        if result.isSuccess {
            print("登录成功，用户名： \(usernameTxt.text!)")
            // 记住登录的用户
            UserDefaults.standard.set(usernameTxt.text!, forKey: "username")
            UserDefaults.standard.synchronize()
            
            // 从 AppDelegate 类中调用 login 方法
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.login()
        } else {
            print("登录失败")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
