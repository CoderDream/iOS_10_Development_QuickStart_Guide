//
//  SignInViewController.swift
//  Instagram
//
//  Created by coderdream on 2018/12/3.
//  Copyright © 2018 coderdream. All rights reserved.
//

import UIKit

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
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
