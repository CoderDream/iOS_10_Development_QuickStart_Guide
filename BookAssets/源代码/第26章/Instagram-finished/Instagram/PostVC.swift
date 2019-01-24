//
//  PostVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/8/2.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

var postuuid = [String]()

class PostVC: UITableViewController {
  
  // 从服务器获取数据后写入到相应的数组中
  var avaArray = [AVFile]()
  var usernameArray = [String]()
  var dateArray = [Date]()
  var picArray = [AVFile]()
  var uuidArray = [String]()
  var titleArray = [String]()
		
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 顶部的标题名称
    self.navigationItem.title = "照片"
    
    // 定义新的返回按钮
    self.navigationItem.hidesBackButton = true
    let backBtn = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back(_:)))
    self.navigationItem.leftBarButtonItem = backBtn
    
    // 向右划动屏幕返回到之前的控制器
    let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back(_:)))
    backSwipe.direction = .right
    self.view.isUserInteractionEnabled = true
    self.view.addGestureRecognizer(backSwipe)
    
    // 动态单元格高度设置
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 450
    
    NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: "liked" as NSNotification.Name?, object: nil)
    
    let postQuery = AVQuery(className: "Posts")
    postQuery?.whereKey("puuid", equalTo: postuuid.last!)
    postQuery?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
      // 清空数组
      self.avaArray.removeAll(keepingCapacity: false)
      self.usernameArray.removeAll(keepingCapacity: false)
      self.dateArray.removeAll(keepingCapacity: false)
      self.picArray.removeAll(keepingCapacity: false)
      self.uuidArray.removeAll(keepingCapacity: false)
      self.titleArray.removeAll(keepingCapacity: false)
      
      for object in objects! {
        self.avaArray.append(object.value(forKey: "ava") as! AVFile)
        self.usernameArray.append(object.value(forKey: "username") as! String)
        self.dateArray.append(object.createdAt)
        self.picArray.append(object.value(forKey: "pic") as! AVFile)
        self.uuidArray.append(object.value(forKey: "puuid") as! String)
        self.titleArray.append(object.value(forKey: "title") as! String)
      }
      self.tableView.reloadData()
    })
    
  }
  
  func refresh() {
    self.tableView.reloadData()
  }
  
  func back(_ sender: UIBarButtonItem){
    _ = self.navigationController?.popViewController(animated: true)
    
    if !postuuid.isEmpty {
      postuuid.removeLast()
    }
  }
  
  @IBAction func usernameBtn_clicked(_ sender: AnyObject) {
    
    // 按钮的 index
    let i = sender.layer.value(forKey: "index") as! IndexPath
    
    // 通过 i 获取到用户所点击的单元格
    let cell = tableView.cellForRow(at: i) as! PostCell
    
    // 如果当前用户点击的是自己的username，则调用HomeVC，否则是GuestVC
    if cell.usernameBtn.titleLabel?.text == AVUser.current().username {
      let home = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
      self.navigationController?.pushViewController(home, animated: true)
    }else {
      let guest = self.storyboard?.instantiateViewController(withIdentifier: "GuestVC") as! GuestVC
      self.navigationController?.pushViewController(guest, animated: true)
    }
    
  }
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return usernameArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // 从表格视图的可复用队列中获取单元格对象
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostCell
    
    // 通过数组信息关联单元格中的UI控件
    cell.usernameBtn.setTitle(usernameArray[indexPath.row], for: .normal)
    cell.usernameBtn.sizeToFit()
    cell.puuidLbl.text = uuidArray[indexPath.row]
    cell.titleLbl.text = titleArray[indexPath.row]
    cell.titleLbl.sizeToFit()
    
    // 配置用户头像
    avaArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
      cell.avaImg.image = UIImage(data: data!)
    }
    
    // 配置帖子照片
    picArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
      cell.picImg.image = UIImage(data: data!)
    }
    
    // 帖子的发布时间和当前时间的间隔差
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
    
    // 根据用户是否喜爱维护likeBtn按钮
    let didLike = AVQuery(className: "Likes")
    didLike?.whereKey("by", equalTo: AVUser.current().username)
    didLike?.whereKey("to", equalTo: cell.puuidLbl.text)
    didLike?.countObjectsInBackground({ (count:Int, error:Error?) in
      if count == 0 {
        cell.likeBtn.setTitle("unlike", for: .normal)
        cell.likeBtn.setBackgroundImage(UIImage(named: "unlike.png"), for: .normal)
      }else {
        cell.likeBtn.setTitle("like", for: .normal)
        cell.likeBtn.setBackgroundImage(UIImage(named: "like.png"), for: .normal)
      }
    })
    
    let countLikes =  AVQuery(className: "Likes")
    countLikes?.whereKey("to", equalTo: cell.puuidLbl.text)
    countLikes?.countObjectsInBackground({ (count:Int, error:Error?) in
      cell.likeLbl.text = "\(count)"
    })
    
    // 将indexPath赋值给usernameBtn的layer属性的自定义变量
    cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
    
    return cell
  }
}
