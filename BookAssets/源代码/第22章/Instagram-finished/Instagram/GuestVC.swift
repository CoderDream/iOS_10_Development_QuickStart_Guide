//
//  GuestVC.swift
//  Instagram
//
//  Created by 铭刘 on 16/7/15.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

var guestArray = [AVUser]()

class GuestVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  var show = String()
  var user = String()
  
  // 从云端获取数据到数组
  var uuidArray = [String]()
  var picArray = [AVFile]()
  
  // 界面对象
  var refresher: UIRefreshControl!
  var page: Int = 12
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 允许垂直的拉拽刷新操作
    self.collectionView?.alwaysBounceVertical = true
    
    // 设置集合视图的背景色为白色
    self.collectionView?.backgroundColor = .white()
    
    // 导航栏的顶部信息
    self.navigationItem.title = guestArray.last?.username
    
    // 定义导航栏中新的返回按钮
    self.navigationItem.hidesBackButton = true
    let backBtn = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back(_:)))
    self.navigationItem.leftBarButtonItem = backBtn
    
    
    // 实现向右划动返回
    let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back(_:)))
    backSwipe.direction = .right
    self.view.addGestureRecognizer(backSwipe)
    
    // 安装refresh控件
    refresher = UIRefreshControl()
    refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
    self.collectionView?.addSubview(refresher)
    
    // 调用loadPosts方法
    loadPosts()
    
  }
  
  func back(_: UIBarButtonItem) {
    // 退回到之前的控制器
    _ = self.navigationController?.popViewController(animated: true)
    
    // 从guestArray中移除最后一个AVUser
    if !guestArray.isEmpty {
      guestArray.removeLast()
    }
  }
  
  // 刷新方法
  func refresh() {
    self.collectionView?.reloadData()
    self.refresher.endRefreshing()
  }
  
  // 载入访客发布的帖子
  func loadPosts() {
    let query = AVQuery(className: "Posts")
    query?.whereKey("username", equalTo: guestArray.last?.username)
    query?.limit = page
    query?.findObjectsInBackground({ (objects:[AnyObject]?, error:NSError?) in
      // 查询成功
      if error == nil {
        // 清空两个数组
        self.uuidArray.removeAll(keepingCapacity: false)
        self.picArray.removeAll(keepingCapacity: false)
        
        for object in objects! {
          // 将查询到的数据添加到数组中
          self.uuidArray.append(object.value(forKey: "puuid") as! String)
          self.picArray.append(object.value(forKey: "pic") as! AVFile)
        }
        
        self.collectionView?.reloadData()
      }else {
        print(error?.localizedDescription)
      }
    })
  }
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.height {
      self.loadMore()
    }
  }
  
  func loadMore( ) {
    if page <= picArray.count {
      page = page + 12
      
      let query = AVQuery(className: "Posts")
      query?.whereKey("username", equalTo: guestArray.last?.username)
      query?.limit = page
      query?.findObjectsInBackground({ (objects:[AnyObject]?, error:NSError?) in
        // 查询成功
        if error == nil {
          // 清空两个数组
          self.uuidArray.removeAll(keepingCapacity: false)
          self.picArray.removeAll(keepingCapacity: false)
          
          for object in objects! {
            // 将查询到的数据添加到数组中
            self.uuidArray.append(object.value(forKey: "puuid") as! String)
            self.picArray.append(object.value(forKey: "pic") as! AVFile)
          }
          print("loaded + \(self.page)")
          self.collectionView?.reloadData()
        }else {
          print(error?.localizedDescription)
        }
      })
    }
  }
  
  // 设置单元格大小
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let size = CGSize(width: self.view.frame.width / 3, height: self.view.frame.width / 3)
    return size
  }
  
  // 有多少单元格
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return picArray.count
  }
  
  // 配置header
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    // 定义header
    let header = self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! HeaderView
    
    // 第1步. 载入访客的数据
    let infoQuery = AVQuery(className: "_User")
    infoQuery?.whereKey("username", equalTo: guestArray.last?.username)
    infoQuery?.findObjectsInBackground({ (objects:[AnyObject]?, error:NSError?) in
      if error == nil {
        // 判断是否有用户数据
        // guard !objects!.isEmpty else{ print("没有该用户！"); return}
        guard let objects = objects , objects.count > 0 else {
          return
        }
        
        // 找到用户的相关信息
        for object in objects {
          header.fullnameLbl.text = (object.objectFor("fullname") as? String)?.uppercased()
          header.bioLbl.text = object.objectFor("bio") as? String
          header.bioLbl.sizeToFit()
          header.webTxt.text = object.objectFor("web") as? String
          header.webTxt.sizeToFit()
          
          let avaFile = object.objectFor("ava") as? AVFile
          avaFile?.getDataInBackground({ (data:Data?, error:NSError?) in
            header.avaImg.image = UIImage(data: data!)
          })
        }
      }else {
        print(error?.localizedDescription)
      }
    })
    
    // 第2步. 设置当前用户和访客之间的关注状态
    let followeeQuery = AVUser.current().followeeQuery()
    followeeQuery?.whereKey("user", equalTo: AVUser.current())
    followeeQuery?.whereKey("followee", equalTo: guestArray.last)
    followeeQuery?.countObjectsInBackground({ (count:Int, error:NSError?) in
      guard error == nil else { print(error?.localizedDescription); return }
      
      if count == 0 {
        header.button.setTitle("关 注", for: .normal)
        header.button.backgroundColor = .lightGray()
      }else {
        header.button.setTitle("√ 已关注", for: .normal)
        header.button.backgroundColor = .green()
      }
    })
    
    // 第3步. 计算统计数据
    // 访客的帖子数
    let posts = AVQuery(className: "Posts")
    posts?.whereKey("username", equalTo: guestArray.last?.username)
    posts?.countObjectsInBackground({ (count:Int, error:NSError?) in
      if error == nil {
        header.posts.text = "\(count)"
      }else {
        print(error?.localizedDescription)
      }
    })
    
    // 访客的关注者数
    let followers = AVUser.followerQuery(guestArray.last?.objectId)
    followers?.countObjectsInBackground({ (count:Int, error:NSError?) in
      if error == nil {
        header.followers.text = "\(count)"
      }else {
        print(error?.localizedDescription)
      }
    })
    
    // 访客的关注数
    let followings = AVUser.followeeQuery(guestArray.last?.objectId)
    followings?.countObjectsInBackground({ (count:Int, error:NSError?) in
      if error == nil {
        header.followings.text = "\(count)"
      }else {
        print(error?.localizedDescription)
      }
    })
    
    // 第4步. 实现统计数据的点击手势
    // 点击posts label
    let postsTap = UITapGestureRecognizer(target: self, action: #selector(postsTap(_:)))
    postsTap.numberOfTapsRequired = 1
    header.posts.isUserInteractionEnabled = true
    header.posts.addGestureRecognizer(postsTap)
    
    // 点击关注者label
    let followersTap = UITapGestureRecognizer(target: self, action: #selector(followersTap(_:)))
    followersTap.numberOfTapsRequired = 1
    header.followers.isUserInteractionEnabled = true
    header.followers.addGestureRecognizer(followersTap)
    
    // 点击关注label
    let followingsTap = UITapGestureRecognizer(target: self, action: #selector(followingsTap(_:)))
    followingsTap.numberOfTapsRequired = 1
    header.followings.isUserInteractionEnabled = true
    header.followings.addGestureRecognizer(followingsTap)
    
    return header
    
  }
  
  // 点击posts label
  func postsTap(_ recognizer: UITapGestureRecognizer) {
    if !picArray.isEmpty {
      let index = IndexPath(item: 0, section: 0)
      self.collectionView?.scrollToItem(at: index, at: .top, animated: true)
    }
  }
  
  // 点击followers label
  func followersTap(_ recognizer: UITapGestureRecognizer) {
    // 从故事板载入FollowersVC的视图
    let followers = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
    
    followers.user = guestArray.last!.username
    followers.show = "关 注 者"
    
    self.navigationController?.pushViewController(followers, animated: true)
  }
  
  // 点击followings label
  func followingsTap(_ recognizer: UITapGestureRecognizer) {
    // 从故事板载入FollowersVC的视图
    let followings = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! FollowersVC
    
    followings.user = guestArray.last!.username
    followings.show = "关 注"
    
    self.navigationController?.pushViewController(followings, animated: true)
  }
  
  // 配置单元格
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    // 定义Cell
    let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PictureCell
    
    //
    picArray[indexPath.row].getDataInBackground { (data:Data?, error:NSError?) in
      if error == nil {
        cell.picImg.image = UIImage(data: data!)
      }else {
        print(error?.localizedDescription)
      }
    }
    return cell
  }
}
