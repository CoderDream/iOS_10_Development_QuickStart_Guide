//
//  UploadVC.swift
//  Instagram
//
//  Created by 铭刘 on 16/7/30.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  // UI objects
  @IBOutlet weak var picImg: UIImageView!
  @IBOutlet weak var titleTxt: UITextView!
  @IBOutlet weak var publishBtn: UIButton!
  @IBOutlet weak var removeBtn: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 默认状态下禁用 publishBtn 按钮
    publishBtn.isEnabled = false
    publishBtn.backgroundColor = .lightGray()
    
    // 隐藏移除按钮
    removeBtn.isHidden = true
    
    // 让UI控件回到初始状态
    picImg.image = UIImage(named: "pbg.jpg")
    titleTxt.text = ""
    
    // 点击时隐藏键盘
    let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
    hideTap.numberOfTapsRequired = 1
    self.view.isUserInteractionEnabled = true
    self.view.addGestureRecognizer(hideTap)
    
    // 点击Image View
    let picTap = UITapGestureRecognizer(target: self, action: #selector(selectImg))
    picTap.numberOfTapsRequired = 1
    self.picImg.isUserInteractionEnabled = true
    self.picImg.addGestureRecognizer(picTap)
    
    alignment()
  }
  
  func hideKeyboardTap() {
    self.view.endEditing(true)
  }
  
  func selectImg() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = .photoLibrary
    picker.allowsEditing = true
    present(picker, animated: true, completion: nil)
  }
  
  // 放大或缩小照片
  func zoomImg() {
    
    let zoomed = CGRect(x: 0, y: self.view.center.y - self.view.center.x, width: self.view.frame.width, height: self.view.frame.width)
    
    let unzoomed = CGRect(x: 15, y: self.navigationController!.navigationBar.frame.height + 35, width: self.view.frame.width / 4.5, height: self.view.frame.width / 4.5)
    
    if picImg.frame == unzoomed {
      UIView.animate(withDuration: 0.3, animations: { 
        self.picImg.frame = zoomed
        
        self.view.backgroundColor = .black()
        self.titleTxt.alpha = 0
        self.publishBtn.alpha = 0
      })
    }else {
      UIView.animate(withDuration: 0.3, animations: { 
        self.picImg.frame = unzoomed
        
        self.view.backgroundColor = .white()
        self.titleTxt.alpha = 1
        self.publishBtn.alpha = 1
      })
    }
    
  }
  
  // 将选择的照片放入picImg，并销毁照片获取器
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    picImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
    self.dismiss(animated: true, completion: nil)
    
    // 允许 publish btn 
    publishBtn.isEnabled = true
    publishBtn.backgroundColor = UIColor(red: 52.0 / 255.0, green: 169.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
    
    // 显示移除按钮
    removeBtn.isHidden = false
    
    // 实现第二次点击放大图片
    let zoomTap = UITapGestureRecognizer(target: self, action: #selector(zoomImg))
    zoomTap.numberOfTapsRequired = 1
    picImg.isUserInteractionEnabled = true
    picImg.addGestureRecognizer(zoomTap)
  }
  
  func alignment() {
    let width = self.view.frame.width
    
    picImg.frame = CGRect(x: 15, y: self.navigationController!.navigationBar.frame.height + 35, width: width / 4.5, height: width / 4.5)
    
    titleTxt.frame = CGRect(x: picImg.frame.width + 25, y: picImg.frame.origin.y, width: width - titleTxt.frame.origin.x - 10, height: picImg.frame.height)
    
    publishBtn.frame = CGRect(x: 0, y: self.tabBarController!.tabBar.frame.origin.y - width / 8, width: width, height: width / 8)
    
    removeBtn.frame = CGRect(x: picImg.frame.origin.x, y: picImg.frame.origin.y + picImg.frame.height, width: picImg.frame.width, height: 30)
  }
  
  @IBAction func publishBtn_clicked(_ sender: AnyObject) {
    // 隐藏键盘
    self.view.endEditing(true)
    
    let object = AVObject(className: "Posts")
    object?["username"] = AVUser.current().username
    object?["ava"] = AVUser.current().value(forKey: "ava") as! AVFile
    object?["puuid"] = "\(AVUser.current().username!) \(NSUUID().uuidString)"
    
    // titleTxt是否为空
    if titleTxt.text.isEmpty {
      object?["title"] = ""
    }else {
      object?["title"] = titleTxt.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    // 生成照片数据
    let imageData = UIImageJPEGRepresentation(picImg.image!, 0.5)
    let imageFile = AVFile(name: "post.jpg", data: imageData)
    object?["pic"] = imageFile
    
    // 将最终数据存储到LeanCloud云端
    object?.saveInBackground({ (success:Bool, error:NSError?) in
      if error == nil {
        // 发送 uploaded 通知
        NotificationCenter.default.post(name: "uploaded" as Notification.Name, object: nil)
        // 将TabBar控制器中索引值为0的子控制器，显示在手机屏幕上。
        self.tabBarController!.selectedIndex = 0
        
        // reset 一切
        self.viewDidLoad()
      }
    })
  }
  
  @IBAction func removeBtn_clicked(_ sender: AnyObject) {
    self.viewDidLoad()
  }
}
