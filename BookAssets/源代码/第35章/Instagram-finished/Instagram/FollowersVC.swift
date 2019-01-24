//
//  FollowersVC.swift
//  Instagram
//
//  Created by 铭刘 on 16/7/14.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

class FollowersVC: UITableViewController {
  
  var show = String()
  var user = String()
  
  var followerArray = [AVUser]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.title = show
    
    // 定义导航栏中新的返回按钮
    self.navigationItem.hidesBackButton = true
    let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: .plain, target: self, action: #selector(back(_:)))
    self.navigationItem.leftBarButtonItem = backBtn
    
    
    // 实现向右划动返回
    let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back(_:)))
    backSwipe.direction = .right
    self.view.addGestureRecognizer(backSwipe)
    
    if show == "关 注 者" {
      loadFollowers()
    }else {
      loadFollowings()
    }
    
  }
  
  func back(_: UIBarButtonItem) {
    // 退回到之前的控制器
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  func loadFollowers() {
    AVUser.current().getFollowers { (followers:[AnyObject]?, error:Error?) in
      if error == nil && followers != nil {
        self.followerArray = followers! as! [AVUser]
        self.tableView.reloadData()
      }else {
        print(error?.localizedDescription)
      }
    }
    
  }
  
  func loadFollowings() {
    AVUser.current().getFollowees { (followings:[AnyObject]?, error:Error?) in
      if error == nil && followings != nil {
        self.followerArray = followings! as! [AVUser]
        self.tableView.reloadData()
      }else {
        print(error?.localizedDescription)
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return followerArray.count
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    return self.view.frame.width / 4
    
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    // 通过indexPath获取用户所点击的单元格的用户对象
    let cell = tableView.cellForRow(at: indexPath) as! FollowersCell
    
    // 如果用户点击单元格，或者进入HomeVC或者进入GuestVC
    if cell.usernameLbl.text == AVUser.current().username {
      let home = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
      self.navigationController?.pushViewController(home, animated: true)
    }else {
      guestArray.append(followerArray[indexPath.row])
      let guest = storyboard?.instantiateViewController(withIdentifier: "GuestVC") as! GuestVC
      self.navigationController?.pushViewController(guest, animated: true)
    }
    
    
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FollowersCell
    
    cell.usernameLbl.text = followerArray[indexPath.row].username
    let ava = followerArray[indexPath.row].object(forKey: "ava")
    ava?.getDataInBackground({ (data:Data?, error:Error?) in
      if error == nil {
        cell.avaImg.image = UIImage(data: data!)
      }else {
        print(error?.localizedDescription)
      }
    })
    
    // 利用按钮外观区分当前用户关注或未关注状态
    let query = followerArray[indexPath.row].followeeQuery()
    query?.whereKey("user", equalTo: AVUser.current())
    query?.whereKey("followee", equalTo: followerArray[indexPath.row])
    query?.countObjectsInBackground({ (count:Int, error:Error?) in
      if error == nil {
        if count == 0 {
          cell.followBtn.setTitle("关 注", for: .normal)
          cell.followBtn.backgroundColor = .lightGray
        }else {
          cell.followBtn.setTitle("√ 已关注", for: .normal)
          cell.followBtn.backgroundColor = .green
        }
      }
    })
    
    //cell.userObjectId = followerArray[indexPath.row].objectId
    cell.user = followerArray[indexPath.row] 
    
    // 为当前用户隐藏关注按钮
    if cell.usernameLbl.text == AVUser.current().username {
      cell.followBtn.isHidden = true
    }
    
    return cell
  }
}
