//
//  HeaderView.swift
//  Instagram
//
//  Created by 刘铭 on 16/7/9.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

class HeaderView: UICollectionReusableView {
  @IBOutlet weak var avaImg: UIImageView!       // 用户头像
  @IBOutlet weak var fullnameLbl: UILabel!      // 用户名称
  @IBOutlet weak var webTxt: UITextView!        // 个人主页地址
  @IBOutlet weak var bioLbl: UILabel!           // 个人简介
  
  @IBOutlet weak var posts: UILabel!            // 帖子数
  @IBOutlet weak var followers: UILabel!        // 关注者数
  @IBOutlet weak var followings: UILabel!       // 关注数
        
  @IBOutlet weak var postTitle: UILabel!        // 帖子的Label
  @IBOutlet weak var followersTitle: UILabel!   // 关注者的Label
  @IBOutlet weak var followingsTitle: UILabel!  // 关注的Label
  
  @IBOutlet weak var button: UIButton!          // 编辑个人主页按钮
  
  // 从GuestVC点击关注按钮
  @IBAction func followBtn_click(_ sender: AnyObject) {
    let title = button.title(for: .normal)
    
    let user = guestArray.last
    
    if title == "关 注" {
      guard user != nil else { return }
      
      AVUser.current().follow(user?.objectId, andCallback: { (success:Bool, error:NSError?) in
        if success {
          self.button.setTitle("√ 已关注", for: .normal)
          self.button.backgroundColor = .green()
        }else {
          print(error?.localizedDescription)
        }
      })
    } else {
      guard user != nil else { return }
      
      AVUser.current().unfollow(user?.objectId, andCallback: { (success:Bool, error:NSError?) in
        if success {
          self.button.setTitle("关 注", for: .normal)
          self.button.backgroundColor = .lightGray()
        }else {
          print(error?.localizedDescription)
        }
      })
    }
  }
  
}
