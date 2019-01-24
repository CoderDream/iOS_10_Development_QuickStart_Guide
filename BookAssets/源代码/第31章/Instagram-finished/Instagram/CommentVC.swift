//
//  CommentVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/8/4.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

var commentuuid = [String]()
var commentowner = [String]()

class CommentVC: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var commentTxt: UITextView!
  @IBOutlet weak var sendBtn: UIButton!
  
  var refresh = UIRefreshControl()
  
  // 将从云端获取到的数据写进的数组
  var usernameArray = [String]()
  var avaArray = [AVFile]()
  var commentArray = [String]()
  var dateArray = [Date]()
  
  // page size
  var page: Int = 15
  
  // 重置UI的默认值
  var tableViewHeight: CGFloat = 0
  var commentY: CGFloat = 0
  var commentHeight: CGFloat = 0
  
  // 存储keyboard大小的变量
  var keyboard = CGRect()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = "评论"
    self.navigationItem.hidesBackButton = true
    let backBtn = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back(_:)))
    self.navigationItem.leftBarButtonItem = backBtn
    
    //self.tableView.backgroundColor = .red
    
    // 在开始的时候，禁止sendBtn按钮
    self.sendBtn.isEnabled = false
    
    // 如果键盘出现或消失，捕获这两个消息
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    
    
    let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back(_:)))
    backSwipe.direction = .right
    self.view.isUserInteractionEnabled = true
    self.view.addGestureRecognizer(backSwipe)
    
    alignment()
    loadComments()
  }
  
  // 当键盘出现的时候会调用该方法
  func keyboardWillShow(_ notification: Notification) {
    // 获取到键盘的大小
    let rect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey]!) as! NSValue
    keyboard = rect.cgRectValue
    
    UIView.animate(withDuration: 0.4, animations: {() -> Void in
      self.tableView.frame.size.height = self.tableViewHeight - self.keyboard.height
      self.commentTxt.frame.origin.y = self.commentY - self.keyboard.height
      self.sendBtn.frame.origin.y = self.commentTxt.frame.origin.y
    
    })
  }
  
  func keyboardWillHide(_ notification: Notification) {
    UIView.animate(withDuration: 0.4, animations: {() -> Void in
      self.tableView.frame.size.height = self.tableViewHeight
      
      self.commentTxt.frame.origin.y = self.commentY
      
      self.sendBtn.frame.origin.y = self.commentY
      
    })
  }
  
  func back(_ sender: UIBarButtonItem) {
    _ = self.navigationController?.popViewController(animated: true)
    
    // 从数组中清除评论的uuid
    if !commentuuid.isEmpty {
      commentuuid.removeLast()
    }
    
    // 从数组中清除评论所有者
    if !commentowner.isEmpty {
      commentowner.removeLast()
    }
  }
  
  func loadComments() {
    // STEP 1. 合计出所有的评论的数量
    let countQuery = AVQuery(className: "Comments")
    countQuery?.whereKey("to", equalTo: commentuuid.last!)
    countQuery?.countObjectsInBackground({ (count:Int, error:Error?) in
      if self.page < count {
        self.refresh.addTarget(self, action: #selector(self.loadMore), for: .valueChanged)
        self.tableView.addSubview(self.refresh)
      }
      
      // STEP 2. 获取最新的self.page数量的评论
      let query = AVQuery(className: "Comments")
      query?.whereKey("to", equalTo: commentuuid.last!)
      query?.skip = count - self.page
      query?.addAscendingOrder("createdAt")
      query?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
        if error == nil {
          // 清空数组
          self.usernameArray.removeAll(keepingCapacity: false)
          self.commentArray.removeAll(keepingCapacity: false)
          self.avaArray.removeAll(keepingCapacity: false)
          self.dateArray.removeAll(keepingCapacity: false)
          
          for object in objects! {
            self.usernameArray.append(object.object(forKey: "username") as! String)
            self.avaArray.append(object.object(forKey: "ava") as! AVFile)
            self.commentArray.append(object.object(forKey: "comment") as! String)
            self.dateArray.append(object.createdAt)
            
            self.tableView.reloadData()
            
            self.tableView.scrollToRow(at: IndexPath(row: self.commentArray.count - 1, section: 0)  , at: .bottom, animated: false)
          }
        }else {
          print(error?.localizedDescription)
        }
      })
    })
  }
  
  func loadMore() {
    // STEP 1. 合计出所有的评论的数量
    let countQuery = AVQuery(className: "Comments")
    countQuery?.whereKey("to", equalTo: commentuuid.last!)
    countQuery?.countObjectsInBackground({ (count:Int, error:Error?) in
      // 让refresh停止刷新动画
      self.refresh.endRefreshing()
      
      if self.page >= count {
        self.refresh.removeFromSuperview()
      }
      
      // STEP 2. 载入更多的评论
      if self.page < count {
        self.page = self.page + 15
        
        // 从云端查询page个记录
        let query = AVQuery(className: "Comments")
        query?.whereKey("to", equalTo: commentuuid.last!)
        query?.skip = count - self.page
        query?.addAscendingOrder("createdAt")
        query?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
          if error == nil {
            // 清空数组
            self.usernameArray.removeAll(keepingCapacity: false)
            self.commentArray.removeAll(keepingCapacity: false)
            self.avaArray.removeAll(keepingCapacity: false)
            self.dateArray.removeAll(keepingCapacity: false)
            
            for object in objects! {
              self.usernameArray.append(object.object(forKey: "username") as! String)
              self.avaArray.append(object.object(forKey: "ava") as! AVFile)
              self.commentArray.append(object.object(forKey: "comment") as! String)
              self.dateArray.append(object.createdAt)
            }
            self.tableView.reloadData()
          }else {
            print(error?.localizedDescription)
          }
        })
      }
    })
  }
  
  // 控制器视图出现在屏幕上调用的方法
  override func viewWillAppear(_ animated: Bool) {
    // 隐藏底部标签栏
    self.tabBarController?.tabBar.isHidden = true
    
    // 调出键盘
    self.commentTxt.becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = false
  }
  
  // 当输入的时候会调用该方法
  func textViewDidChange(_ textView: UITextView) {
    // 如果没有输入信息则禁止按钮
    let spacing = CharacterSet.whitespacesAndNewlines
    if !textView.text.trimmingCharacters(in: spacing).isEmpty {
      sendBtn.isEnabled = true
    }else {
      sendBtn.isEnabled = false
    }
    
    if textView.contentSize.height > textView.frame.height && textView.frame.height < 130 {
      
      let difference = textView.contentSize.height - textView.frame.height
      textView.frame.origin.y = textView.frame.origin.y - difference
      textView.frame.size.height = textView.contentSize.height
      
      // 上移tableView
      if textView.contentSize.height + keyboard.height + commentY >= tableView.frame.height {
        tableView.frame.size.height = tableView.frame.size.height - difference
      }
    }else if textView.contentSize.height < textView.frame.height {
      let difference = textView.frame.height - textView.contentSize.height
      
      textView.frame.origin.y = textView.frame.origin.y + difference
      textView.frame.size.height = textView.contentSize.height
      
      // 上移tableView
      if textView.contentSize.height + keyboard.height + commentY > tableView.frame.height {
        tableView.frame.size.height = tableView.frame.size.height + difference
      }
    }
  }
  
  @IBAction func usernameBtn_clicked(_ sender: AnyObject) {
    // 按钮的 index
    let i = sender.layer.value(forKey: "index") as! IndexPath
    
    // 通过 i 获取到用户所点击的单元格
    let cell = tableView.cellForRow(at: i) as! CommentCell
    
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
  
  
  @IBAction func sendBtn_clicked(_ sender: AnyObject) {
    
    // STEP 1. 在表格视图中添加一行
    usernameArray.append(AVUser.current().username!)
    avaArray.append(AVUser.current().object(forKey: "ava") as! AVFile)
    dateArray.append(Date())
    commentArray.append(commentTxt.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
    tableView.reloadData()
    
    // STEP 2. 发送评论到云端
    let commentObj = AVObject(className: "Comments")
    commentObj?["to"] = commentuuid.last!
    commentObj?["username"] = AVUser.current().username
    commentObj?["ava"] = AVUser.current().object(forKey: "ava")
    commentObj?["comment"] = commentTxt.text.trimmingCharacters(in: .whitespacesAndNewlines)
    commentObj?.saveEventually()
    
    // STEP 3. 发送hashtag到云端
    let words: [String] = commentTxt.text.components(separatedBy: CharacterSet.whitespacesAndNewlines)
    
    for var word in words {
      //定义正则表达式
      let pattern = "#[^#]+";
      let regular = try! NSRegularExpression(pattern: pattern, options:.caseInsensitive)
      let results = regular.matches(in: word, options: .reportProgress , range: NSMakeRange(0, word.characters.count))
      
      //输出截取结果
      print("符合的结果有\(results.count)个")
      for result in results {
        word = (word as NSString).substring(with: result.range)
      }
      
      if word.hasPrefix("#") {
        word = word.trimmingCharacters(in: CharacterSet.punctuation)
        word = word.trimmingCharacters(in: CharacterSet.symbols)
        
        let hashtagObj = AVObject(className: "Hashtags")
        hashtagObj?["to"] = commentuuid.last
        hashtagObj?["by"] = AVUser.current().username
        hashtagObj?["hashtag"] = word.lowercased()
        hashtagObj?["comment"] = commentTxt.text
        hashtagObj?.saveInBackground({ (success:Bool, error:Error?) in
          if success {
            print("hashtag \(word) 已经被创建。")
          }else {
            print(error?.localizedDescription)
          }
        })
      }
    }
    
    // scroll to bottom
    self.tableView.scrollToRow(at: IndexPath(item: commentArray.count - 1, section: 0), at: .bottom, animated: false)
    
    // STEP 3. 重置UI
    commentTxt.text = ""
    commentTxt.frame.size.height = commentHeight
    commentTxt.frame.origin.y = sendBtn.frame.origin.y
    tableView.frame.size.height = tableViewHeight - keyboard.height - commentTxt.frame.height + commentHeight
    
    
  }
  
  
  
  // TableView Method
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return commentArray.count
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  // 所有单元格可编辑
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  // 划动单元格的Action
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
    // 获取用户所划动的单元格对象
    let cell = tableView.cellForRow(at: indexPath) as! CommentCell
    
    // Action 1. Delete
    let delete = UITableViewRowAction(style: .normal, title: "   "){(UITableViewRowAction, IndexPath) -> Void in
      // STEP 1. 从云端删除评论
      let commentQuery = AVQuery(className: "Comments")
      commentQuery?.whereKey("to", equalTo: commentuuid.last!)
      commentQuery?.whereKey("comment", equalTo: cell.commentLbl.text!)
      commentQuery?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
        if error == nil {
          // 找到相关记录
          for object in objects! {
            object.deleteEventually()
          }
        }else {
          print(error?.localizedDescription)
        }
      })
      
      // STEP 2. 从云端删除 hashtag
      let hashtagQuery = AVQuery(className: "Hashtags")
      hashtagQuery?.whereKey("to", equalTo: commentuuid.last)
      hashtagQuery?.whereKey("by", equalTo: cell.usernameBtn.titleLabel?.text)
      hashtagQuery?.whereKey("comment", equalTo: cell.commentLbl.text)
      hashtagQuery?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
        if error == nil {
          for object in objects! {
            object.deleteEventually()
          }
        }
      })
      
      // STEP 3. 从表格视图删除单元格
      self.commentArray.remove(at: indexPath.row)
      self.dateArray.remove(at: indexPath.row)
      self.avaArray.remove(at: indexPath.row)
      self.usernameArray.remove(at: indexPath.row)
      
      self.tableView.deleteRows(at: [indexPath], with: .fade)
      
      // 关闭单元格的编辑状态
      self.tableView.setEditing(false, animated: true)
    }
    
    // Action 2. Address
    let address = UITableViewRowAction(style: .normal, title: "   ") {(action:UITableViewRowAction, indexPath: IndexPath) -> Void in
      
      // 在Text View中包含Address
      self.commentTxt.text = "\(self.commentTxt.text + "@" + self.usernameArray[indexPath.row] + " ")"
      // 让发送按钮生效
      self.sendBtn.isEnabled = true
      // 关闭单元格的编辑状态
      self.tableView.setEditing(false, animated: true)
    }
    
    // Action 3. 投诉评论
    let complain = UITableViewRowAction(style: .normal, title: "   "){(action: UITableViewRowAction, indexPath: IndexPath) -> Void in
    
      // 发送投诉到云端
      let complainObj = AVObject(className: "Complain")
      complainObj?["by"] = AVUser.current().username
      complainObj?["post"] = commentuuid.last
      complainObj?["to"] = cell.commentLbl.text
      complainObj?["owner"] = cell.usernameBtn.titleLabel?.text
      
      complainObj?.saveInBackground({ (success:Bool, error:Error?) in
        if success {
          self.alert(error: "投诉信息已经被成功提交！", message: "感谢您的支持，我们将关注您提交的投诉！")
        }else{
          self.alert(error: "错误", message: error!.localizedDescription)
        }
      })
      
      // 关闭单元格的编辑状态
      self.tableView.setEditing(false, animated: true)
    }
    
    // 按钮的背景颜色
    delete.backgroundColor = UIColor(patternImage: UIImage(named: "delete.png")!)
    address.backgroundColor = UIColor(patternImage: UIImage(named: "address.png")!)
    complain.backgroundColor = UIColor(patternImage: UIImage(named: "complain.png")!)
    
    if cell.usernameBtn.titleLabel?.text == AVUser.current().username {
      return [delete, address]
    }else if commentowner.last == AVUser.current().username {
      return [delete, address, complain]
    }else {
      return [address, complain]
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CommentCell
    
    cell.usernameBtn.setTitle(usernameArray[indexPath.row], for: .normal)
    cell.usernameBtn.sizeToFit()
    cell.commentLbl.text = commentArray[indexPath.row]
    avaArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
      cell.avaImg.image = UIImage(data: data!)
    }
    
    // 计算时间
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
    
    // @mentions is tapped
    cell.commentLbl.userHandleLinkTapHandler = { label, handle, rang in
      
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
          }
        })
      }
    }
    
    // #hashtag is tapped
    cell.commentLbl.hashtagLinkTapHandler = { label, handle, rang in
      var mention = handle
      mention = String(mention.characters.dropFirst())
      hashtag.append(mention)
      
      let hashvc = self.storyboard?.instantiateViewController(withIdentifier: "HashtagsVC") as! HashtagsVC
      self.navigationController?.pushViewController(hashvc, animated: true)
      
    }
    
    cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
    
    return cell
  }
  
  // 消息警告
  func alert(error: String, message: String) {
    let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(ok)
    self.present(alert, animated: true, completion: nil)
  }
  
  // 对齐UI控件
  func alignment() {
    let width = self.view.frame.width
    let height = self.view.frame.height
    
    tableView.frame = CGRect(x: 0, y: 0, width: width, height: height / 1.096 - self.navigationController!.navigationBar.frame.height - 20)
    
    tableView.estimatedRowHeight = width / 5.33
    tableView.rowHeight = UITableViewAutomaticDimension
    
    commentTxt.frame = CGRect(x: 10, y: tableView.frame.height + height / 56.8, width: width / 1.306, height: 33)
    
    commentTxt.layer.cornerRadius = commentTxt.frame.width / 50
    
    // delegate
    commentTxt.delegate = self
    tableView.delegate = self
    tableView.dataSource = self
    
    sendBtn.frame = CGRect(x: commentTxt.frame.origin.x + commentTxt.frame.width + width / 32, y: commentTxt.frame.origin.y, width: width - (commentTxt.frame.origin.x + commentTxt.frame.width) - width / 32 * 2, height: commentTxt.frame.height)
    
    // assign reseting values
    tableViewHeight = tableView.frame.height
    commentHeight = commentTxt.frame.height
    commentY = commentTxt.frame.origin.y
  }

}
