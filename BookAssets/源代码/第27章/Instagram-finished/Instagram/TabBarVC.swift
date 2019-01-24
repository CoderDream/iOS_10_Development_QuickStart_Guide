//
//  TabBarVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/8/3.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 每个Item的文字颜色为白色
    self.tabBar.tintColor = .white
    
    // 标签栏的背景色
    self.tabBar.barTintColor = UIColor(red: 37.0/255.0, green: 39.0/255.0, blue: 42.0/255.0, alpha: 1)
    
    self.tabBar.isTranslucent = false
  }
  
}
