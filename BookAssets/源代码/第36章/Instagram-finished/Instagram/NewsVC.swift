//
//  NewsVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/8/14.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

class NewsVC: UITableViewController {
  
  // 存储云端数据到数组
  var usernameArray = [String]()
  var avaArray = [AVFile]()
  var typeArray = [String]()
  var dateArray = [Date]()
  var uuidArray = [String]()
  var ownerArray = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 动态调整表格的高度
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 60
    
    // 导航栏的title
    self.navigationItem.title = "通知"
    
    // 从云端载入通知数据
    let query = AVQuery(className: "News")
    query?.whereKey("to", equalTo: AVUser.current().username)
    query?.limit = 30
    query?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
      if error == nil {
        self.usernameArray.removeAll(keepingCapacity: false)
        self.avaArray.removeAll(keepingCapacity: false)
        self.typeArray.removeAll(keepingCapacity: false)
        self.dateArray.removeAll(keepingCapacity: false)
        self.uuidArray.removeAll(keepingCapacity: false)
        self.ownerArray.removeAll(keepingCapacity: false)
        
        for object in objects! {
          self.usernameArray.append(object.value(forKey: "by") as! String)
          self.avaArray.append(object.value(forKey: "ava") as! AVFile)
          self.typeArray.append(object.value(forKey: "type") as! String)
          self.dateArray.append(object.createdAt)
          self.uuidArray.append(object.value(forKey: "puuid") as! String)
          self.ownerArray.append(object.value(forKey: "owner") as! String)
          
          object.setObject("yes", forKey: "checked")
          object.saveEventually()
        }
        
        UIView.animate(withDuration: 1, animations: { 
          icons.alpha = 0
          corner.alpha = 0
          dot.alpha = 0
        })
        self.tableView.reloadData()
      }
    })
  }
  
  @IBAction func usernameBtn_clicked(_ sender: AnyObject) {
    
    // 按钮的 index
    let i = sender.layer.value(forKey: "index") as! IndexPath
    
    // 通过 i 获取到用户所点击的单元格
    let cell = tableView.cellForRow(at: i) as! NewsCell
    
    // 如果当前用户点击的是自己的username，则调用HomeVC，否则是GuestVC
    if cell.usernameBtn.titleLabel?.text == AVUser.current().username {
      let home = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
      self.navigationController?.pushViewController(home, animated: true)
    }else {
      let query = AVUser.query()
      query?.whereKey("username", equalTo: cell.usernameBtn.titleLabel?.text)
      query?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
        if let object = objects?.last {
          guestArray.append(object as! AVUser)
          
          let guest = self.storyboard?.instantiateViewController(withIdentifier: "GuestVC") as! GuestVC
          self.navigationController?.pushViewController(guest, animated: true)
        }
      })
    }
    
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return usernameArray.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // 从可复用队列中获取单元格对象
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsCell
    
    cell.usernameBtn.setTitle(usernameArray[indexPath.row], for: .normal)
    avaArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
      if error == nil {
        cell.avaImg.image = UIImage(data: data!)
      }else {
        print(error?.localizedDescription)
      }
    }
    
    // 消息的发布时间和当前时间的间隔差
    let from = dateArray[indexPath.row]
    let now = Date()
    let components : Set<Calendar.Component> = [.second, .minute, .hour, .day, .weekOfMonth]
    let difference = Calendar.current.dateComponents(components, from: from, to: now)
    
    if difference.second <= 0 {
      cell.dateLbl.text = "现在"
    }
    
    if difference.second > 0 && difference.minute <= 0 {
      cell.dateLbl.text = "\(difference.second!)秒."
    }
    
    if difference.minute > 0 && difference.hour <= 0 {
      cell.dateLbl.text = "\(difference.minute!)分."
    }
    
    if difference.hour > 0 && difference.day <= 0 {
      cell.dateLbl.text = "\(difference.hour!)时."
    }
    
    if difference.day > 0 && difference.weekOfMonth <= 0 {
      cell.dateLbl.text = "\(difference.day!)天."
    }
    
    if difference.weekOfMonth > 0 {
      cell.dateLbl.text = "\(difference.weekOfMonth!)周."
    }
    
    // 定义info文本信息
    if typeArray[indexPath.row] == "mention" {
      cell.infoLbl.text = "@mention了你"
    }
    if typeArray[indexPath.row] == "comment" {
      cell.infoLbl.text = "评论了你的帖子"
    }
    if typeArray[indexPath.row] == "follow" {
      cell.infoLbl.text = "关注了你"
    }
    if typeArray[indexPath.row] == "like" {
      cell.infoLbl.text = "喜欢你的帖子"
    }
    
    // 赋值indexPath给usernameBtn
    cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
    
    
    return cell
  }
  
  // 点击单元格
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! NewsCell
    
    // 跳转到comment或@mention
    if cell.infoLbl.text == "评论了你的帖子" || cell.infoLbl.text == "@mention了你" {
      commentuuid.append(uuidArray[indexPath.row])
      commentowner.append(ownerArray[indexPath.row])
      
      // 跳转到评论页面
      let comments = self.storyboard?.instantiateViewController(withIdentifier: "CommentVC") as! CommentVC
      self.navigationController?.pushViewController(comments, animated: true)
    }
    
    // 跳转到关注人的页面
    if cell.infoLbl.text == "关注了你" {
      // 获取关注人的AVUser对象
      let query = AVUser.query()
      query?.whereKey("username", equalTo: cell.usernameBtn.titleLabel?.text)
      query?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
        if let object = objects?.last {
          guestArray.append(object as! AVUser)
          
          // 跳转到访客页面
          let guest = self.storyboard?.instantiateViewController(withIdentifier: "GuestVC") as! GuestVC
          self.navigationController?.pushViewController(guest, animated: true)
        }
      })
    }
    
    // 跳转到帖子页面
    if cell.infoLbl.text == "喜欢你的帖子" {
      postuuid.append(uuidArray[indexPath.row])
      
      let post = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostVC
      self.navigationController?.pushViewController(post, animated: true)
    }
  }
  
}
