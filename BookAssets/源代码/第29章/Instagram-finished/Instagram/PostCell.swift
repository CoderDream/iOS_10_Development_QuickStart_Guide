//
//  PostCell.swift
//  Instagram
//
//  Created by 刘铭 on 16/8/2.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

class PostCell: UITableViewCell {
  
  @IBOutlet weak var avaImg: UIImageView!
  @IBOutlet weak var usernameBtn: UIButton!
  @IBOutlet weak var dateLbl: UILabel!
  
  // 帖子照片
  @IBOutlet weak var picImg: UIImageView!
  
  // 按钮
  @IBOutlet weak var likeBtn: UIButton!
  @IBOutlet weak var commentBtn: UIButton!
  @IBOutlet weak var moreBtn: UIButton!
  
  // Labels
  @IBOutlet weak var likeLbl: UILabel!
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var puuidLbl: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    let width = UIScreen.main.bounds.width
    
    // 设置likeBtn按钮的title文字的颜色为无色，title的文本内容只作为程序的判断使用
    likeBtn.setTitleColor(.clear, for: .normal)
    
    // 双击照片添加喜爱
    let likeTap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
    likeTap.numberOfTapsRequired = 2
    picImg.isUserInteractionEnabled = true
    picImg.addGestureRecognizer(likeTap)
    
    // 启用约束
    avaImg.translatesAutoresizingMaskIntoConstraints = false
    usernameBtn.translatesAutoresizingMaskIntoConstraints = false
    dateLbl.translatesAutoresizingMaskIntoConstraints = false
    
    picImg.translatesAutoresizingMaskIntoConstraints = false
    
    likeBtn.translatesAutoresizingMaskIntoConstraints = false
    commentBtn.translatesAutoresizingMaskIntoConstraints = false
    moreBtn.translatesAutoresizingMaskIntoConstraints = false
    
    likeLbl.translatesAutoresizingMaskIntoConstraints = false
    titleLbl.translatesAutoresizingMaskIntoConstraints = false
    puuidLbl.translatesAutoresizingMaskIntoConstraints = false
    
    let picWidth = width - 20
    
    // 约束
    self.contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-10-[ava(30)]-10-[pic(\(picWidth))]-5-[like(30)]", options: [], metrics: nil, views: ["ava": avaImg, "pic": picImg, "like": likeBtn]))
    
    self.contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-10-[username]", options: [], metrics: nil, views: ["username": usernameBtn]))
    
    self.contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:[pic]-5-[comment(30)]", options: [], metrics: nil, views: ["pic": picImg, "comment": commentBtn]))
    
    self.contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-15-[date]", options: [], metrics: nil, views: ["date": dateLbl]))
    
    self.contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:[like]-5-[title]-5-|", options: [], metrics: nil, views: ["like": likeBtn, "title": titleLbl]))
    
    self.contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:[pic]-5-[more(30)]", options: [], metrics: nil, views: ["pic": picImg, "more": moreBtn]))
    
    self.contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "V:[pic]-10-[likes]", options: [], metrics: nil, views: ["pic": picImg, "likes": likeLbl]))
    
    self.contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-10-[ava(30)]-10-[username]", options: [], metrics: nil, views: ["ava": avaImg, "username": usernameBtn]))
    
    self.contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-0-[pic]-0-|", options: [], metrics: nil, views: ["pic": picImg]))
    
    self.contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-15-[like(30)]-10-[likes]-20-[comment(30)]", options: [], metrics: nil, views: ["like": likeBtn, "likes": likeLbl, "comment": commentBtn]))
    
    self.contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:[more(30)]-15-|", options: [], metrics: nil, views: ["more": moreBtn]))
    
    self.contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-15-[title]-15-|", options: [], metrics: nil, views: ["title": titleLbl]))
    
    self.contentView.addConstraints(NSLayoutConstraint.constraints(
      withVisualFormat: "H:|[date]-10-|", options: [], metrics: nil, views: ["date": dateLbl]))
    
    avaImg.layer.cornerRadius = avaImg.frame.width / 2
    avaImg.clipsToBounds = true
  }
  
  
  @IBAction func likeBtn_clicked(_ sender: AnyObject) {
    // 获取likeBtn按钮的Title
    let title = sender.title(for: .normal)
    
    if title == "unlike" {
      let object = AVObject(className: "Likes")
      object?["by"] = AVUser.current().username
      object?["to"] = puuidLbl.text
      object?.saveInBackground({ (success:Bool, error:Error?) in
        if success {
          print("标记为：like！")
          self.likeBtn.setTitle("like", for: .normal)
          self.likeBtn.setBackgroundImage(UIImage(named: "like.png"), for: .normal)
          
          // 如果设置为喜爱，则发送通知给表格视图刷新表格
          NotificationCenter.default.post(name: "liked" as Notification.Name, object: nil)
        }
      })
    }else {
      // 搜索Likes表中对应的记录
      let query = AVQuery(className: "Likes")
      query?.whereKey("by", equalTo: AVUser.current().username)
      query?.whereKey("to", equalTo: puuidLbl.text)
      query?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
        for object in objects! {
          // 搜索到记录以后将其从Likes表中删除
          object.deleteInBackground({ (success:Bool, error:Error?) in
            if success {
              print("删除like记录，disliked")
              self.likeBtn.setTitle("unlike", for: .normal)
              self.likeBtn.setBackgroundImage(UIImage(named: "unlike.png"), for: .normal)
              
              // 如果设置为喜爱，则发送通知给表格视图刷新表格
              NotificationCenter.default.post(name: "liked" as Notification.Name, object: nil)
            }
          })
        }
      })
    }
  }
  
  func likeTapped() {
    // 创建一个大的灰色桃心
    let likePic = UIImageView(image: UIImage(named: "unlike.png"))
    likePic.frame.size.width = picImg.frame.width / 1.5
    likePic.frame.size.height = picImg.frame.height / 1.5
    likePic.center = picImg.center
    likePic.alpha = 0.8
    self.addSubview(likePic)
    
    // 通过动画隐藏likePic并且让它变小
    UIView.animate(withDuration: 0.4, animations: {
      likePic.alpha = 0
      likePic.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    })
    
    let title = likeBtn.title(for: .normal)
    
    if title == "unlike" {
      let object = AVObject(className: "Likes")
      object?["by"] = AVUser.current().username
      object?["to"] = puuidLbl.text
      object?.saveInBackground({ (success:Bool, error:Error?) in
        if success {
          print("标记为：like！")
          self.likeBtn.setTitle("like", for: .normal)
          self.likeBtn.setBackgroundImage(UIImage(named: "like.png"), for: .normal)
          
          // 如果设置为喜爱，则发送通知给表格视图刷新表格
          NotificationCenter.default.post(name: "liked" as Notification.Name, object: nil)
        }
      })
    }
  }
  
}
