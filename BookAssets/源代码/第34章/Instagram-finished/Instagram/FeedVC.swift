//
//  FeedVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/8/12.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

class FeedVC: UITableViewController {
  
  @IBOutlet weak var indicator: UIActivityIndicatorView!
  
  var refresher = UIRefreshControl()
  
  // 存储云端数据的数组
  var usernameArray = [String]()
  var avaArray = [AVFile]()
  var dateArray = [Date]()
  var picArray = [AVFile]()
  var titleArray = [String]()
  var uuidArray = [String]()
  
  // 存储当前用户所关注的人
  var followArray = [String]()
  
  // page size
  var page: Int = 10
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 导航栏的title
    self.navigationItem.title = "聚合"
    
    // 设置单元格的动态行高
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 450
    
    // 设置refresher
    refresher.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
    self.view.addSubview(refresher)
    
    NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: "liked" as NSNotification.Name?, object: nil)

    // 从UploadVC类接收Notification
    NotificationCenter.default.addObserver(self, selector: #selector(uploaded(notification:)), name: "uploaded" as Notification.Name, object: nil)
    
    // 让indicator水平居中
    indicator.center.x = tableView.center.x
    
    // 从云端载入帖子记录
    loadPosts()
  }
  
  // 在接收到uploaded通知后重新载入posts
  func uploaded(notification: Notification) {
    loadPosts()
  }
  
  func refresh() {
    self.tableView.reloadData()
  }
  
  // 从云端载入帖子
  func loadPosts() {
    AVUser.current().getFollowees { (objects:[AnyObject]?, error:Error?) in
      if error == nil {
        
        // 清空数组
        self.followArray.removeAll(keepingCapacity: false)
        
        for object in objects! {
          self.followArray.append(object.username)
        }
        
        // 添加当前用户到followArray数组中
        self.followArray.append(AVUser.current().username)
        
        let query = AVQuery(className: "Posts")
        query?.whereKey("username", containedIn: self.followArray)
        query?.limit = self.page
        query?.addDescendingOrder("createdAt")
        query?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
          if error == nil {
            // 清空数组
            self.usernameArray.removeAll(keepingCapacity: false)
            self.avaArray.removeAll(keepingCapacity: false)
            self.dateArray.removeAll(keepingCapacity: false)
            self.picArray.removeAll(keepingCapacity: false)
            self.titleArray.removeAll(keepingCapacity: false)
            self.uuidArray.removeAll(keepingCapacity: false)
            
            for object in objects! {
              self.usernameArray.append(object.value(forKey: "username") as! String)
              self.avaArray.append(object.value(forKey: "ava") as! AVFile)
              self.dateArray.append(object.createdAt)
              self.picArray.append(object.value(forKey: "pic") as! AVFile)
              self.titleArray.append(object.value(forKey: "title") as! String)
              self.uuidArray.append(object.value(forKey: "puuid") as! String)

            }
            
            // reload tableView
            self.tableView.reloadData()
            self.refresher.endRefreshing()
            
          }else {
            print(error?.localizedDescription)
          }
        })
      }
    }
  }
  
  func loadMore() {
    // 如果云端获取到的帖子数大于page数
    if self.page <= uuidArray.count {
      // 开始Indicator动画
      indicator.startAnimating()
      
      // 将page数量+10
      page = page + 10
      
      AVUser.current().getFollowees { (objects:[AnyObject]?, error:Error?) in
        if error == nil {
          
          // 清空数组
          self.followArray.removeAll(keepingCapacity: false)
          
          for object in objects! {
            self.followArray.append(object.username)
          }
          
          // 添加当前用户到followArray数组中
          self.followArray.append(AVUser.current().username)
          
          let query = AVQuery(className: "Posts")
          query?.whereKey("username", containedIn: self.followArray)
          query?.limit = self.page
          query?.addDescendingOrder("createdAt")
          query?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
            if error == nil {
              // 清空数组
              self.usernameArray.removeAll(keepingCapacity: false)
              self.avaArray.removeAll(keepingCapacity: false)
              self.dateArray.removeAll(keepingCapacity: false)
              self.picArray.removeAll(keepingCapacity: false)
              self.titleArray.removeAll(keepingCapacity: false)
              self.uuidArray.removeAll(keepingCapacity: false)
              
              for object in objects! {
                self.usernameArray.append(object.value(forKey: "username") as! String)
                self.avaArray.append(object.value(forKey: "ava") as! AVFile)
                self.dateArray.append(object.createdAt)
                self.picArray.append(object.value(forKey: "pic") as! AVFile)
                self.titleArray.append(object.value(forKey: "title") as! String)
                self.uuidArray.append(object.value(forKey: "puuid") as! String)
                
              }

              // reload tableView
              self.tableView.reloadData()
              self.indicator.stopAnimating()

            }else {
              print(error?.localizedDescription)
            }
          })
        }
      }
    }
  }
  
  // MARK: - Table view data source
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.height * 2 {
      loadMore()
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return uuidArray.count
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
    cell.commentBtn.layer.setValue(indexPath, forKey: "index")
    cell.moreBtn.layer.setValue(indexPath, forKey: "index")
    
    // @mentions is tapped
    cell.titleLbl.userHandleLinkTapHandler = { label, handle, rang in
      
      var mention = handle
      mention = String(mention.characters.dropFirst())
      
      if mention.lowercased() == AVUser.current().username {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.navigationController?.pushViewController(home, animated: true)
      }else {
        let query = AVUser.query()
        query?.whereKey("username", equalTo: mention.lowercased())
        query?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
          if let object = objects?.last {
            guestArray.append(object as! AVUser)
            
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "GuestVC") as! GuestVC
            self.navigationController?.pushViewController(guest, animated: true)
          }else {
            let alert = UIAlertController(title: "\(mention.uppercased())", message: "用尽力洪荒之力，也没有发现该用户的存在！", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
          }
        })
      }
    }
    
    // #hashtag is tapped
    cell.titleLbl.hashtagLinkTapHandler = { label, handle, rang in
      var mention = handle
      mention = String(mention.characters.dropFirst())
      hashtag.append(mention.lowercased())
      
      let hashvc = self.storyboard?.instantiateViewController(withIdentifier: "HashtagsVC") as! HashtagsVC
      self.navigationController?.pushViewController(hashvc, animated: true)
      
    }
    
    
    return cell
  }

  // 点击comment 按钮
  @IBAction func commentBtn_clicked(_ sender: AnyObject) {
    let i = sender.layer.value(forKey: "index") as! IndexPath
    let cell = tableView.cellForRow(at: i) as! PostCell
    
    // 发送相关数据到全局变量
    commentuuid.append(cell.puuidLbl.text!)
    commentowner.append(cell.usernameBtn.titleLabel!.text!)
    
    // 需要在故事板中查看Storyboard ID是否设置
    let comment = self.storyboard?.instantiateViewController(withIdentifier: "CommentVC") as! CommentVC
    self.navigationController?.pushViewController(comment, animated: true)
  }
  
  @IBAction func moreBtn_clicked(_ sender: AnyObject) {
    let i = sender.layer.value(forKey: "index") as! IndexPath
    let cell = tableView.cellForRow(at: i) as! PostCell
    
    // 删除操作
    let delete = UIAlertAction(title: "删除", style: .default){(UIAlertAction)->Void in
      // STEP 1. 从表格视图中删除行
      self.usernameArray.remove(at: i.row)
      self.avaArray.remove(at: i.row)
      self.picArray.remove(at: i.row)
      self.dateArray.remove(at: i.row)
      self.titleArray.remove(at: i.row)
      self.uuidArray.remove(at: i.row)
      
      // STEP 2. 删除云端的记录
      let postQuery = AVQuery(className: "Posts")
      postQuery?.whereKey("puuid", equalTo: cell.puuidLbl.text)
      postQuery?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
        if error == nil {
          for object in objects! {
            object.deleteInBackground({ (success:Bool, error:Error?) in
              if success {
                // 发送通知到rootViewController更新帖子
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "uploaded"), object: nil)
                
                // 销毁当前控制器
                _ = self.navigationController?.popViewController(animated: true)
              }else {
                print(error?.localizedDescription)
              }
            })
          }
        }else {
          print(error?.localizedDescription)
        }
      })
      
      // STEP 3. 删除帖子的Like记录
      let likeQuery = AVQuery(className: "Likes")
      likeQuery?.whereKey("to", equalTo: cell.puuidLbl.text)
      likeQuery?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
        if error == nil {
          for object in objects! {
            object.deleteEventually()
          }
        }
      })
      
      // STEP 4. 删除帖子相关的评论
      let commentQuery = AVQuery(className: "Comments")
      commentQuery?.whereKey("to", equalTo: cell.puuidLbl.text)
      commentQuery?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
        if error == nil {
          for object in objects! {
            object.deleteEventually()
          }
        }
      })
      
      // STEP 5. 删除帖子相关的Hashtag
      let hashtagQuery = AVQuery(className: "Hashtags")
      hashtagQuery?.whereKey("to", equalTo: cell.puuidLbl.text)
      hashtagQuery?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
        if error == nil {
          for object in objects! {
            object.deleteEventually()
          }
        }
      })
    }
    
    // 投诉操作
    let complain = UIAlertAction(title: "投诉", style: .default) {(UIAlertAction) -> Void in
      // 发送投诉到云端Complain数据表
      let complainObject = AVObject(className: "Complain")
      complainObject?["by"] = AVUser.current().username
      complainObject?["post"] = cell.puuidLbl.text
      complainObject?["to"] = cell.titleLbl.text
      complainObject?["owner"] = cell.usernameBtn.titleLabel?.text
      complainObject?.saveInBackground({ (success:Bool, error:Error?) in
        if success {
          self.alert(error: "投诉信息已经被成功提交！", message: "感谢您的支持，我们将关注您提交的投诉！")
        }else{
          self.alert(error: "错误", message: error!.localizedDescription)
        }
      })
    }
    
    // 取消操作
    let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
    
    // 创建菜单控制器
    let menu = UIAlertController(title: "菜单选项", message: nil, preferredStyle: .actionSheet)
    
    if cell.usernameBtn.titleLabel?.text == AVUser.current().username {
      menu.addAction(delete)
      menu.addAction(cancel)
    }else {
      menu.addAction(complain)
      menu.addAction(cancel)
    }
    
    // 显示菜单
    self.present(menu, animated: true, completion: nil)
  }
  
  // 消息警告
  func alert(error: String, message: String) {
    let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(ok)
    self.present(alert, animated: true, completion: nil)
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
}
