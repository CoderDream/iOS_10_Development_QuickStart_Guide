//
//  ResetPasswordVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/6/23.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

class ResetPasswordVC: UIViewController {
  
  @IBOutlet weak var emailTxt: UITextField!
  @IBOutlet weak var resetBtn: UIButton!
  @IBOutlet weak var cancelBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // UI元素布局
    emailTxt.frame = CGRect(x: 10, y: 120, width: self.view.frame.width - 20, height: 30)
    resetBtn.frame = CGRect(x: 20, y: emailTxt.frame.origin.y + 50, width: self.view.frame.width / 4, height: 30)
    cancelBtn.frame = CGRect(x: self.view.frame.width / 4 * 3 - 20, y: resetBtn.frame.origin.y, width: self.view.frame.width / 4, height: 30)
    
    // 隐藏虚拟键盘的点击手势
    let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    hideTap.numberOfTapsRequired = 1
    self.view.isUserInteractionEnabled = true
    self.view.addGestureRecognizer(hideTap)
    
    //设置背景图
    let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
    
    bg.image = UIImage(named: "bg.jpg")
    bg.layer.zPosition = -1
    self.view.addSubview(bg)
  }
  
  func hideKeyboard(recognizer: UITapGestureRecognizer) {
    self.view.endEditing(true)
  }
  
  @IBAction func resetBtn_click(_ sender: AnyObject) {
    // 隐藏键盘
    self.view.endEditing(true)
    
    if emailTxt.text!.isEmpty {
      let alert = UIAlertController(title: "请注意", message: "电子邮件不能为空", preferredStyle: .alert)
      let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alert.addAction(ok)
      self.present(alert, animated: true, completion: nil)
      
      return
    }
    
    AVUser.requestPasswordResetForEmail(inBackground: emailTxt.text) { (success:Bool, error:Error?) in
      if success {
        let alert = UIAlertController(title: "请注意", message: "重置密码连接已经发送到您的电子邮件！", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (_) in
          self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
      }else {
        print(error?.localizedDescription)
      }
    }
  }
  
  @IBAction func cancelBtn_click(_ sender: AnyObject) {
    
    self.view.endEditing(true)
    
    self.dismiss(animated: true, completion: nil)
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
