//
//  SignUpVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/6/23.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet weak var avaImg: UIImageView!
  
  @IBOutlet weak var usernameTxt: UITextField!
  @IBOutlet weak var passwordTxt: UITextField!
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
    
    // 改变avaImg的外观为圆形
    avaImg.layer.cornerRadius = avaImg.frame.width / 2
    avaImg.clipsToBounds = true
    
    let imgTap = UITapGestureRecognizer(target: self, action: #selector(loadImg))
    imgTap.numberOfTapsRequired = 1
    avaImg.isUserInteractionEnabled = true
    avaImg.addGestureRecognizer(imgTap)
    
    // UI元素布局
    avaImg.frame = CGRect(x: self.view.frame.width / 2 - 40, y: 40, width: 80, height: 80)
    
    let viewWidth = self.view.frame.width
    usernameTxt.frame = CGRect(x: 10, y: avaImg.frame.origin.y + 90, width: viewWidth - 20, height: 30)
    passwordTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: viewWidth - 20, height: 30)
    repeatPasswordTxt.frame = CGRect(x: 10, y: passwordTxt.frame.origin.y + 40, width: viewWidth - 20, height: 30)
    
    emailTxt.frame = CGRect(x: 10, y: repeatPasswordTxt.frame.origin.y + 60, width: viewWidth - 20, height: 30)
    fullnameTxt.frame = CGRect(x: 10, y: emailTxt.frame.origin.y + 40, width: viewWidth - 20, height: 30)
    bioTxt.frame = CGRect(x: 10, y: fullnameTxt.frame.origin.y + 40, width: viewWidth - 20, height: 30)
    webTxt.frame = CGRect(x: 10, y: bioTxt.frame.origin.y + 40, width: viewWidth - 20, height: 30)
    
    signUpBtn.frame = CGRect(x: 20, y: webTxt.frame.origin.y + 50, width: viewWidth / 4, height: 30)
    cancelBtn.frame = CGRect(x: viewWidth - viewWidth / 4 - 20, y: signUpBtn.frame.origin.y, width: viewWidth / 4, height: 30)
    
    //设置背景图
    let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
    
    bg.image = UIImage(named: "bg.jpg")
    bg.layer.zPosition = -1
    self.view.addSubview(bg)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // 调出照片获取器选择照片
  func loadImg(recognizer: UITapGestureRecognizer) {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = .photoLibrary
    picker.allowsEditing = true
    present(picker, animated: true, completion: nil)
  }
  
  // 关联选择好的照片图像到image view
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
    self.dismiss(animated: true, completion: nil)
  }
  
  // 用户取消获取器操作时调用的方法
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.dismiss(animated: true, completion: nil)
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
    
    // 隐藏keyboard
    self.view.endEditing(true)
    
    if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || repeatPasswordTxt.text!.isEmpty || emailTxt.text!.isEmpty || fullnameTxt.text!.isEmpty || bioTxt.text!.isEmpty || webTxt.text!.isEmpty {
      let alert = UIAlertController(title: "请注意", message: "请填写好所有的字段", preferredStyle: .alert)
      let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alert.addAction(ok)
      self.present(alert, animated: true, completion: nil)
      
      return
    }
    
    // 如果两次输入的密码不同
    if passwordTxt.text != repeatPasswordTxt.text {
      let alert = UIAlertController(title: "请注意", message: "两次输入的密码不一致", preferredStyle: .alert)
      let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alert.addAction(ok)
      self.present(alert, animated: true, completion: nil)
      
      return
    }
    
    let user = AVUser()
    user.username = usernameTxt.text?.lowercased()
    user.email = emailTxt.text?.lowercased()
    user.password = passwordTxt.text
    user["fullname"] = fullnameTxt.text?.lowercased()
    user["bio"] = bioTxt.text
    user["web"] = webTxt.text?.lowercased()
    user["gender"] = ""
    
    // 转换头像数据并发送到服务器
    let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
    let avaFile = AVFile(name: "ava.jpg", data: avaData)
    user["ava"] = avaFile
    
    // 保存信息到服务器
    user.signUpInBackground { (success:Bool, error:Error?) in
      if success {
        print("用户注册成功！")
        
        // 记住登陆的用户
        UserDefaults.standard.set(user.username, forKey: "username")
        UserDefaults.standard.synchronize()
        
        // 将avaFile直接写入到当前用户的ava字段中
        AVUser.current().setObject(avaFile, forKey: "ava")
        
        // 从AppDelegate类中调用login方法
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.login()
        
      }else {
        print(error?.localizedDescription)
      }
    }
  }
  
  // 取消按钮被点击
  @IBAction func cancelBtn_click(_ sender: AnyObject) {
    self.view.endEditing(true)
    self.dismiss(animated: true, completion: nil)
  }
  
  
}
