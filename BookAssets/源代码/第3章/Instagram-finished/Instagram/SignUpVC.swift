//
//  SignUpVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/6/23.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
  
  @IBOutlet weak var avaImg: UIImageView!
  
  @IBOutlet weak var usernameTxt: UITextField!
  @IBOutlet weak var passworTxt: UITextField!
  @IBOutlet weak var repeatPasswordTxt: UITextField!
  @IBOutlet weak var emailTxt: UITextField!
  
  @IBOutlet weak var fullnameTxt: UITextField!
  @IBOutlet weak var bioTxt: UITextField!
  @IBOutlet weak var webTxt: UITextField!
  
  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var signUpBtn: UIButton!
  @IBOutlet weak var cancelBtn: UIButton!
  
  
  // 根据需要，设置滚动视图的高度
  var scrollViewHeight: CGFloat = 0
  
  // 获取虚拟键盘的大小
  var keyboard: CGRect = CGRect()
		
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // 注册按钮被点击
  @IBAction func signUpBtn_click(_ sender: AnyObject) {
    print("注册按钮被按下！")
  }
  
  // 取消按钮被点击
  @IBAction func cancelBtn_click(_ sender: AnyObject) {
    print("取消按钮被按下！")
    self.dismiss(animated: true, completion: nil)
  }
  
  
}
