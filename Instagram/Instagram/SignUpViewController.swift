//
//  SignUpViewController.swift
//  Instagram
//
//  Created by coderdream on 2018/12/3.
//  Copyright © 2018 coderdream. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // ImageView 用于显示用户头像
    @IBOutlet weak var avaImg: UIImageView!
    
    // 用户名、密码、重复密码、电子邮件的Outlet关联
    @IBOutlet weak var usernameTxt: UITextField!    
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatPasswordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    // 姓名、简介、网站的Outlet关联
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    
    // 注册和取消按钮的Outlet关联
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    // 滚动视图的Outlet关联
    @IBOutlet weak var scrollView: UIScrollView!
    
    // 根据需要，设置滚动视图的高度
    var scrollViewHeight: CGFloat = 0
    
    // 获取虚拟键盘的大小
    var keyboard: CGRect = CGRect()
    
    // 注册按钮单击事件
    @IBAction func signUpBtnClicked(_ sender: UIButton) {
        print("注册按钮被单击")
    }
    
    // 取消按钮单击事件
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        print("取消按钮被单击")
        
        // 以动画的方式去除通过modally方式添加进来的控制器
        self.dismiss(animated: true, completion: nil)
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
