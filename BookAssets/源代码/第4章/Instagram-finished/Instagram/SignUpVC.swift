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
    
    // 滚动视图的frame size
    scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    scrollView.contentSize.height = self.view.frame.height
    scrollViewHeight = self.view.frame.height
    
    // 检测键盘出现或消失的状态
    NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: Notification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
    
    let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
    hideTap.numberOfTapsRequired = 1
    self.view.isUserInteractionEnabled = true
    self.view.addGestureRecognizer(hideTap)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // 隐藏视图中的虚拟键盘
  func hideKeyboardTap(recognizer: UITapGestureRecognizer) {
    self.view.endEditing(true)
  }
  
  func showKeyboard(notification: Notification) {
    
    // 定义keyboard大小
    let rect = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]!)!) as! NSValue
    keyboard = rect.cgRectValue
    
    // 当虚拟键盘出现以后，将滚动视图的实际高度缩小为屏幕高度减去键盘的高度。
    UIView.animate(withDuration: 0.4) {
      self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.size.height
    }
  }

  func hideKeyboard(notification: Notification) {
    // 当虚拟键盘消失后，将滚动视图的实际高度改变为屏幕的高度值。
    UIView.animate(withDuration: 0.4) {
      self.scrollView.frame.size.height = self.view.frame.height
    }
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
