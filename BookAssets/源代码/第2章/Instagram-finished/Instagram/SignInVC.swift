//
//  SignInVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/6/23.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit

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
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
