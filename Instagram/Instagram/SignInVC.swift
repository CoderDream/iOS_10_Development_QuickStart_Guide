//
//  SignInVC.swift
//  Instagram
//
//  Created by coderdream on 2018/12/2.
//  Copyright © 2018 coderdream. All rights reserved.
//

import UIKit

class SignInVC: UITableViewCell {

    // 输入框：用户名、密码
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    // 按钮：登录、注册
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    // 按钮：忘记密码
    @IBOutlet weak var forgotBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func signInBtnClicked(_ sender: UIButton) {
        print("登录按钮被单击")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
