//
//  NavVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/8/3.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit

class NavVC: UINavigationController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 导航栏中Title的颜色设置
    self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    // 导航栏中按钮的颜色
    self.navigationBar.tintColor = .white
    // 导航栏的背景色
    self.navigationBar.barTintColor = UIColor(red: 18.0/255.0, green: 86.0/255.0, blue: 136.0/255.0, alpha: 1)
    // 不允许透明
    self.navigationBar.isTranslucent = false
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle{
    return .lightContent
  }
  
}
