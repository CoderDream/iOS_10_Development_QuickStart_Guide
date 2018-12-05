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
