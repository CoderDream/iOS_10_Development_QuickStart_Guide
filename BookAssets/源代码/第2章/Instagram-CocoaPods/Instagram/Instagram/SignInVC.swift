//
//  SignInVC.swift
//  Instagram
//
//  Created by 铭刘 on 16/8/18.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
  
  // text fields
  @IBOutlet weak var usernameTxt: UITextField!
  @IBOutlet weak var passwordTxt: UITextField!
  
  // buttons
  @IBOutlet weak var signInBtn: UIButton!
  @IBOutlet weak var signUpBtn: UIButton!
  @IBOutlet weak var forgotBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  @IBAction func signInBtn_clicked(_ sender: UIButton) {
    print("登录按钮被点击")
  }
  
  
}
