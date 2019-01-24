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

class CommentVC: UIViewController, UITextViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var commentTxt: UITextView!
  @IBOutlet weak var sendBtn: UIButton!
  
  var refresh = UIRefreshControl()
  
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
    
    commentTxt.delegate = self
    
    sendBtn.frame = CGRect(x: commentTxt.frame.origin.x + commentTxt.frame.width + width / 32, y: commentTxt.frame.origin.y, width: width - (commentTxt.frame.origin.x + commentTxt.frame.width) - width / 32 * 2, height: commentTxt.frame.height)
    
    // assign reseting values
    tableViewHeight = tableView.frame.height
    commentHeight = commentTxt.frame.height
    commentY = commentTxt.frame.origin.y
  }

}
