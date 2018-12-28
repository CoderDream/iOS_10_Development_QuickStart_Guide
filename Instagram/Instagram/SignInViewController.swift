//
//  SignInViewController.swift
//  Instagram
//
//  Created by coderdream on 2018/12/3.
//  Copyright © 2018 coderdream. All rights reserved.
//

import UIKit
import LeanCloud

class SignInViewController: UIViewController {
    
    // 输入框：用户名、密码
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    // 按钮：登录、注册
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    // 按钮：忘记密码
    @IBOutlet weak var forgotBtn: UIButton!
    
    @IBAction func signInBtnClicked(_ sender: UIButton) {
        print("登录按钮被单击")
        
        // 隐藏键盘
        self.view.endEditing(true)
        
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            // 弹出提示对话框
            let alert = UIAlertController(title: "请注意", message: "请填写好所有的字段", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // 实现用户登录功能
        let result = LCUser.logIn(username: usernameTxt.text!, password: passwordTxt.text!)
        
        if result.isSuccess {
            print("用户登录成功")
            
            // 记住登录的用户
            UserDefaults.standard.set(usernameTxt.text!, forKey: "username")
            UserDefaults.standard.synchronize()
            
            // 从 AppDelegate 类中调用 login 方法
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.login()
        } else {
            print("")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 声明隐藏虚拟键盘的操作
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
    }
    
    // 隐藏视图中的虚拟键盘
    @objc func hideKeyboard(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
