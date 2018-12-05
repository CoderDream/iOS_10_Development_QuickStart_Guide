//
//  ResetPasswordViewController.swift
//  Instagram2018
//
//  Created by CoderDream on 2018/12/5.
//  Copyright © 2018 CoderDream. All rights reserved.
//

import UIKit
import LeanCloud

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    @IBAction func resetBtnClick(_ sender: AnyObject) {
        // 隐藏键盘
        self.view.endEditing(true)
        
        if emailTxt.text!.isEmpty {
            let alert = UIAlertController(title: "请注意", message: "电子邮件不能为空", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }    
    
        // 数据存储开发指南 · Swift
        // https://leancloud.cn/docs/leanstorage_guide-swift.html#hash1214212664
        let result:LCBooleanResult = LCUser.requestPasswordReset(email: emailTxt.text!)
        
        switch result {
        case .success:
             print("用户重置密码成功")
            let alert = UIAlertController(title: "请注意", message: "重置密码连接已经发送到您的电子邮件！", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            break
        case .failure(let error):
            print("用户重置密码失败")
            print(error.localizedDescription)
            break
        }
        
    }
    
    @IBAction func cancelBtnClick(_ sender: AnyObject) {
        // 在单击取消按钮的时候隐藏键盘
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
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
    
    @objc func hideKeyboard(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
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
