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
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // 对齐
    let width = UIScreen.main.bounds.width
    
    avaImg.frame = CGRect(x: width / 16, y: width / 16, width: width / 4, height: width / 4)
    
    posts.frame = CGRect(x: width / 2.5, y: avaImg.frame.origin.y, width: 50, height: 30)
    followers.frame = CGRect(x: width / 1.6, y: avaImg.frame.origin.y, width: 50, height: 30)
    followings.frame = CGRect(x: width / 1.2, y: avaImg.frame.origin.y, width: 50, height: 30)
    
    postTitle.center = CGPoint(x: posts.center.x, y: posts.center.y + 20)
    followersTitle.center = CGPoint(x: followers.center.x, y: followers.center.y + 20)
    followingsTitle.center = CGPoint(x: followings.center.x, y: followings.center.y + 20)
    
    button.frame = CGRect(x: postTitle.frame.origin.x, y: postTitle.center.y + 20, width: width - postTitle.frame.origin.x - 10, height: 30)
    button.layer.cornerRadius = button.frame.width / 50
    
    fullnameLbl.frame = CGRect(x: avaImg.frame.origin.x, y: avaImg.frame.origin.y + avaImg.frame.height, width: width - 30, height: 30)
    webTxt.frame = CGRect(x: avaImg.frame.origin.x - 5, y: fullnameLbl.frame.origin.y + 15, width: width - 30, height: 30)
    bioLbl.frame = CGRect(x: avaImg.frame.origin.x, y: webTxt.frame.origin.y + 30, width: width - 30, height: 30)
    
    // 让头像呈圆形显示
    avaImg.layer.cornerRadius = avaImg.frame.width / 2
    avaImg.clipsToBounds = true
    
    
  }
  
  // 从GuestVC点击关注按钮
  @IBAction func followBtn_click(_ sender: AnyObject) {
    let title = button.title(for: .normal)
    
    let user = guestArray.last
    
    if title == "关 注" {
      guard user != nil else { return }
      
      AVUser.current().follow(user?.objectId, andCallback: { (success:Bool, error:Error?) in
        if success {
          self.button.setTitle("√ 已关注", for: .normal)
          self.button.backgroundColor = .green
          
          // 发送关注通知
          let newsObj = AVObject(className: "News")
          newsObj?["by"] = AVUser.current().username
          newsObj?["ava"] = AVUser.current().object(forKey: "ava") as! AVFile
          newsObj?["to"] = guestArray.last?.username
          newsObj?["owner"] = ""
          newsObj?["puuid"] = ""
          newsObj?["type"] = "follow"
          newsObj?["checked"] = "no"
          newsObj?.saveEventually()
          
        }else {
          print(error?.localizedDescription)
        }
      })
    } else {
      guard user != nil else { return }
      
      AVUser.current().unfollow(user?.objectId, andCallback: { (success:Bool, error:Error?) in
        if success {
          self.button.setTitle("关 注", for: .normal)
          self.button.backgroundColor = .lightGray
          
          // 删除关注通知
          let newsQuery = AVQuery(className: "News")
          newsQuery?.whereKey("by", equalTo: AVUser.current().username)
          newsQuery?.whereKey("to", equalTo: guestArray.last?.username)
          newsQuery?.whereKey("type", equalTo: "follow")
          newsQuery?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
            if error == nil {
              for object in objects! {
                object.deleteEventually()
              }
            }
          })
        }else {
          print(error?.localizedDescription)
        }
      })
    }
  }
  
}
