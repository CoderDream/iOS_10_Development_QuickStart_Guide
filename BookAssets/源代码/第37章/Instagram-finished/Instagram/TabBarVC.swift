//
//  TabBarVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/8/3.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

// 关于icons的全局变量
var icons = UIScrollView()
var corner = UIImageView()
var dot = UIView()

class TabBarVC: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 每个Item的文字颜色为白色
    self.tabBar.tintColor = .white
    
    // 标签栏的背景色
    self.tabBar.barTintColor = UIColor(red: 37.0/255.0, green: 39.0/255.0, blue: 42.0/255.0, alpha: 1)
    
    self.tabBar.isTranslucent = false
    
    // 自定义标签按钮
    let itemWidth = self.view.frame.width / 5
    let itemHeight = self.tabBar.frame.height
    let button = UIButton(frame: CGRect(x: itemWidth * 2, y: self.view.frame.height - itemHeight, width: itemWidth - 10, height: itemHeight))
    button.setBackgroundImage(UIImage(named:"upload.png"), for: .normal)
    button.adjustsImageWhenHighlighted = false
    button.addTarget(self, action: #selector(uploaded), for: .touchUpInside)
    self.view.addSubview(button)
    
    
    // 创建icon条
    icons.frame = CGRect(x: self.view.frame.width / 5 * 3 + 10, y: self.view.frame.height - self.tabBar.frame.height * 2 - 3, width: 50, height: 35)
    self.view.addSubview(icons)
    
    // 创建 corner
    corner.frame = CGRect(x: icons.frame.origin.x, y: icons.frame.origin.y + icons.frame.height, width: 20, height: 14)
    corner.center.x = icons.center.x
    corner.image = UIImage(named: "corner.png")
    corner.isHidden = true
    self.view.addSubview(corner)
    
    // 创建 dot
    dot.frame = CGRect(x: self.view.frame.width / 5 * 3, y: self.view.frame.height - 5, width: 7, height: 7)
    dot.center.x = self.view.frame.width / 5 * 3 + (self.view.frame.width / 5) / 2
    dot.backgroundColor = UIColor(red: 251/255, green: 103/255, blue: 29/255, alpha: 1.0)
    dot.layer.cornerRadius = dot.frame.width / 2
    dot.isHidden = true
    self.view.addSubview(dot)
    
    // 显示所有通知Icon
    query(type: ["like"], image: UIImage(named: "likeIcon.png")!)
    query(type: ["follow"], image: UIImage(named: "followIcon.png")!)
    query(type: ["mention", "comment"], image: UIImage(named: "commentIcon.png")!)
    
    
    UIView.animate(withDuration: 1, delay: 8, options: [], animations: {() -> Void in
        icons.alpha = 0
        corner.alpha = 0
        dot.alpha = 0
      }, completion: nil)
  }
  
  func query(type:[String], image: UIImage) {
    let query = AVQuery(className: "News")
    query?.whereKey("to", equalTo: AVUser.current().username)
    query?.whereKey("checked", equalTo: "no")
    //query?.whereKey("type", equalTo: type)
    query?.whereKey("type", containedIn: type)
    
    query?.countObjectsInBackground({ (count:Int, error:Error?) in
      if error == nil {
        if count > 0 {
          self.placeIcon(image: image, text: "\(count)")
        }
      }else {
        print(error?.localizedDescription)
      }
    })
  }
  
  func placeIcon(image: UIImage, text: String) {
    // 创建Icon
    let view = UIImageView(frame: CGRect(x: icons.contentSize.width, y: 0, width: 50, height: 35))
    view.image = image
    icons.addSubview(view)
    
    // 创建Label
    let label = UILabel(frame: CGRect(x: view.frame.width / 2, y: 0, width: view.frame.width / 2, height: view.frame.height))
    label.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
    label.text = text
    label.textAlignment = .center
    label.textColor = .white
    view.addSubview(label)
    
    // 调整icons视图的frame
    icons.frame.size.width = icons.frame.width + view.frame.width - 4
    icons.contentSize.width = icons.contentSize.width + view.frame.width - 4
    icons.center.x = self.view.frame.width / 5 * 4 - (self.view.frame.width / 5) / 4
    
    // 显示隐藏的控件
    corner.isHidden = false
    dot.isHidden = false
  }
  
  func uploaded(sender: UIButton) {
    self.selectedIndex = 2
  }
  
}
