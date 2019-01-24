//
//  EditVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/7/19.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

class EditVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  // UI 对象
  // 滚动视图
  @IBOutlet weak var scrollView: UIScrollView!
  
  // 个人头像
  @IBOutlet weak var avaImg: UIImageView!
  
  // 上半部分的信息
  @IBOutlet weak var fullnameTxt: UITextField!
  @IBOutlet weak var usernameTxt: UITextField!
  @IBOutlet weak var webTxt: UITextField!
  @IBOutlet weak var bioTxt: UITextView!
  
  // 私人信息Label
  @IBOutlet weak var titleLbl: UILabel!
  
  // 下半部分的信息
  @IBOutlet weak var emailTxt: UITextField!
  @IBOutlet weak var telTxt: UITextField!
  @IBOutlet weak var genderTxt: UITextField!
  
  // PickerView和PickerData
  var genderPicker: UIPickerView!
  let genders = ["男", "女"]
  
  var keyboard = CGRect()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 在视图中创建PickerView
    genderPicker = UIPickerView()
    genderPicker.dataSource = self
    genderPicker.delegate = self
    genderPicker.backgroundColor = UIColor.groupTableViewBackground
    genderPicker.showsSelectionIndicator = true
    genderTxt.inputView = genderPicker
    
    // 检测键盘出现或消失的状态
    NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: Notification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
    
    let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
    hideTap.numberOfTapsRequired = 1
    self.view.isUserInteractionEnabled = true
    self.view.addGestureRecognizer(hideTap)
    
    // 点击image view
    let imgTap = UITapGestureRecognizer(target: self, action: #selector(loadImg))
    imgTap.numberOfTapsRequired = 1
    avaImg.isUserInteractionEnabled = true
    avaImg.addGestureRecognizer(imgTap)
    
    // 调用布局方法
    alignment()
    
    // 调用信息载入方法
    information()
  }
  
  // 获取用户信息
  func information() {
    // 获取用户头像并显示到avaImg中
    let ava = AVUser.current().object(forKey: "ava") as! AVFile
    ava.getDataInBackground { (data:Data?, error:Error?) in
      self.avaImg.image = UIImage(data: data!)
    }
    
    // 接收个人用户的文本信息
    usernameTxt.text = AVUser.current().username
    fullnameTxt.text = AVUser.current().object(forKey: "fullname") as? String
    bioTxt.text = AVUser.current().object(forKey: "bio") as? String
    webTxt.text = AVUser.current().object(forKey: "web") as? String
    emailTxt.text = AVUser.current().email
    telTxt.text = AVUser.current().mobilePhoneNumber
    genderTxt.text = AVUser.current().object(forKey: "gender") as? String
    
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
  
  // 隐藏视图中的虚拟键盘
  func hideKeyboardTap(recognizer: UITapGestureRecognizer) {
    self.view.endEditing(true)
  }
  
  func showKeyboard(notification: Notification) {
    
    // 定义keyboard大小
    let rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    keyboard = rect.cgRectValue
    
    // 当虚拟键盘出现以后，将滚动视图的内容高度变为控制器视图高度加上键盘高度的一半。
    UIView.animate(withDuration: 0.4) {
      self.scrollView.contentSize.height = self.view.frame.height + self.keyboard.height / 2
    }
  }
  
  func hideKeyboard(notification: Notification) {
    // 当虚拟键盘消失后，将滚动视图的内容高度值改变为0，这样滚动视图会根据实际内容设置大小。
    UIView.animate(withDuration: 0.4) {
      self.scrollView.contentSize.height = 0
    }
  }
  
  // 界面布局
  func alignment() {
    let width = self.view.frame.width
    let height = self.view.frame.height
    
    scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
    
    avaImg.frame = CGRect(x: width - 68 - 10, y: 15, width: 68, height: 68)
    avaImg.layer.cornerRadius = avaImg.frame.width / 2
    avaImg.clipsToBounds = true
    
    fullnameTxt.frame = CGRect(x: 10, y: avaImg.frame.origin.y, width: width - avaImg.frame.width - 30, height: 30)
    usernameTxt.frame = CGRect(x: 10, y: fullnameTxt.frame.origin.y + 40, width: width - avaImg.frame.width - 30, height: 30)
    webTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: width - 20, height: 30)
    
    bioTxt.frame = CGRect(x: 10, y: webTxt.frame.origin.y + 40, width: width - 20, height: 60)
    bioTxt.layer.borderWidth = 1
    bioTxt.layer.borderColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1).cgColor
    bioTxt.layer.cornerRadius = bioTxt.frame.width / 50
    bioTxt.clipsToBounds = true
    
    titleLbl.frame = CGRect(x: 10, y: bioTxt.frame.origin.y + 100, width: width - 20, height: 30)
    emailTxt.frame = CGRect(x: 10, y: titleLbl.frame.origin.y + 40, width: width - 20, height: 30)
    telTxt.frame = CGRect(x: 10, y: emailTxt.frame.origin.y + 40, width: width - 20, height: 30)
    genderTxt.frame = CGRect(x: 10, y: telTxt.frame.origin.y + 40, width: width - 20, height: 30)
  }
  
  // 获取器方法
  // 设置获取器的组件数量
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  // 设置获取器中选项的数量
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return genders.count
  }
  
  // 设置获取器的选项Title
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return genders[row]
  }
  
  // 从获取器中得到用户选择的Item
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    genderTxt.text = genders[row]
    self.view.endEditing(true)
  }
  
  // 正则检查Email有效性
  func validateEmail(email: String) -> Bool {
    let regex = "\\w[-\\w.+]*@([A-Za-z0-9][-A-Za-z0-9]+\\.)+[A-Za-z]{2,14}"
    let range = email.range(of: regex, options: .regularExpression)
    let result = range != nil ? true : false
    return result
  }
  
  // 正则检查Web有效性
  func validateWeb(web: String) -> Bool {
    let regex = "www\\.[A-Za-z0-9._%+-]+\\.[A-Za-z]{2,14}"
    let range = web.range(of: regex, options: .regularExpression)
    let result = range != nil ? true : false
    return result
  }
  
  // 正则检查手机号码有效性
  func validateMobilePhoneNumber(mobilePhoneNumber: String) -> Bool {
    let regex = "0?(13|14|15|18)[0-9]{9}"
    let range = mobilePhoneNumber.range(of: regex, options: .regularExpression)
    let result = range != nil ? true : false
    return result
  }
  
  // 消息警告
  func alert(error: String, message: String) {
    let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(ok)
    self.present(alert, animated: true, completion: nil)
  }
  
  // 点击保存按钮的实现代码
  @IBAction func save_clicked(_ sender: AnyObject) {
    if !validateEmail(email: emailTxt.text!) {
      alert(error: "错误的Email地址", message: "请输入正确的电子邮件地址")
      return
    }
    
    if !validateWeb(web: webTxt.text!) {
      alert(error: "错误的网页链接", message: "请输入正确的网址")
      return
    }
    
    
    if !telTxt.text!.isEmpty {
      if !validateMobilePhoneNumber(mobilePhoneNumber: telTxt.text!) {
        alert(error: "错误的手机号码", message: "请输入正确的手机号码")
        return
      }
    }
    
    // 保存Field信息到服务器中
    let user = AVUser.current()
    user?.username = usernameTxt.text?.lowercased()
    user?.email = emailTxt.text?.lowercased()
    user?["fullname"] = fullnameTxt.text?.lowercased()
    user?["web"] = webTxt.text?.lowercased()
    user?["bio"] = bioTxt.text
    
    // 如果 tel 为空，则发送""给mobilePhoneNumber字段，否则传入信息
    if telTxt.text!.isEmpty {
      user?.mobilePhoneNumber = ""
    }else {
      user?.mobilePhoneNumber = telTxt.text
    }
    
    // 如果 gender 为空，则发送""给gender字段，否则传入信息
    if genderTxt.text!.isEmpty {
      user?["gender"] = ""
    }else {
      user?["gender"] = genderTxt.text
    }
    
    // 发送头像图片到服务器
    let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
    let avaFile = AVFile(name: "ava.jpg", data: avaData)
    user?["ava"] = avaFile
    
    
    // 发送用户信息到服务器
    user?.saveInBackground({ (success:Bool, error:Error?) in
      if success {
        // 隐藏键盘
        self.view.endEditing(true)
        
        // 退出EditVC控制器
        self.dismiss(animated: true, completion: nil)
        
        NotificationCenter.default.post(name: "reload" as NSNotification.Name, object: nil)
      }else {
        print(error?.localizedDescription)
      }
    })
  }
  
  // 点击取消按钮的实现代码
  @IBAction func cancel_clicked(_ sender: AnyObject) {
    // 隐藏虚拟键盘
    self.view.endEditing(true)
    // 销毁个人信息编辑控制器
    self.dismiss(animated: true, completion: nil)
  }
  
  
}
