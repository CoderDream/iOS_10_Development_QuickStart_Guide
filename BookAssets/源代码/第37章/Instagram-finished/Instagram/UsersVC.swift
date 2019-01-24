//
//  UsersVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/8/14.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

class UsersVC: UITableViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  // 搜索栏
  var searchBar = UISearchBar()
  
  // 从云端获取信息后保存数据的数组
  var usernameArray = [String]()
  var avaArray = [AVFile]()
  
  // 集合视图 UI
  var collectionView: UICollectionView!
  var picArray = [AVFile]()
  var uuidArray = [String]()
  var page: Int = 24
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 实现Search Bar功能
    searchBar.delegate = self
    searchBar.showsCancelButton = true
    searchBar.sizeToFit()
    searchBar.tintColor = UIColor.groupTableViewBackground
    searchBar.frame.size.width = self.view.frame.width - 30
    let searchItem = UIBarButtonItem(customView: searchBar)
    self.navigationItem.leftBarButtonItem = searchItem
    
    // load users
    loadUsers()
    
    // 启动集合视图
    collectionViewLaunch()
  }
  
  func loadUsers() {
    let usersQuery = AVUser.query()
    usersQuery?.addDescendingOrder("createdAt")
    usersQuery?.limit = 20
    usersQuery?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
      if error == nil {
        // 清空数组
        self.usernameArray.removeAll(keepingCapacity: false)
        self.avaArray.removeAll(keepingCapacity: false)
        
        for object in objects! {
          self.usernameArray.append(object.username)
          self.avaArray.append(object.value(forKey: "ava") as! AVFile)
        }
        
        // 刷新表格视图
        self.tableView.reloadData()
      }else {
        print(error?.localizedDescription)
      }
    })
  }
  
  func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let userQuery = AVUser.query()
    userQuery?.whereKey("username", matchesRegex: "(?i)" + searchBar.text!)
    userQuery?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
      if error == nil {
        
        if objects!.isEmpty {
          let fullnameQuery = AVUser.query()
          fullnameQuery?.whereKey("fullname", matchesRegex: "(?i)" + searchBar.text!)
          fullnameQuery?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
            if error == nil {
              // 清空数组
              self.usernameArray.removeAll(keepingCapacity: false)
              self.avaArray.removeAll(keepingCapacity: false)
              
              // 查找相关数据
              for object in objects! {
                self.usernameArray.append(object.username)
                self.avaArray.append(object.value(forKey: "ava") as! AVFile)
              }
              
              self.tableView.reloadData()
            }
          })
        }else {
          // 清空数组
          self.usernameArray.removeAll(keepingCapacity: false)
          self.avaArray.removeAll(keepingCapacity: false)
          
          // 查找相关数据
          for object in objects! {
            self.usernameArray.append(object.username)
            self.avaArray.append(object.value(forKey: "ava") as! AVFile)
          }
          
          self.tableView.reloadData()
        }
      }
    })
    
    return true
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    // 当开始搜索的时候，隐藏集合视图
    collectionView.isHidden = true
    
    searchBar.showsCancelButton = true
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //当搜索结束后显示集合视图
    collectionView.isHidden = false
    
    searchBar.resignFirstResponder()
    
    searchBar.showsCancelButton = false
    
    searchBar.text = ""
    
    loadUsers()
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return usernameArray.count
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return self.view.frame.width / 4
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FollowersCell
    
    // 隐藏 followBtn 按钮
    cell.followBtn.isHidden = true
    
    cell.usernameLbl.text = usernameArray[indexPath.row]
    avaArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
      if error == nil {
        cell.avaImg.image = UIImage(data: data!)
      }
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // 获取当前用户选择的单元格对象
    let cell = tableView.cellForRow(at: indexPath) as! FollowersCell
    
    if cell.usernameLbl.text == AVUser.current().username {
      let home = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
      self.navigationController?.pushViewController(home, animated: true)
    }else {
      let query = AVUser.query()
      query?.whereKey("username", equalTo: cell.usernameLbl.text)
      query?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
        if let object = objects?.last {
          guestArray.append(object as! AVUser)
          
          let guest = self.storyboard?.instantiateViewController(withIdentifier: "GuestVC") as! GuestVC
          self.navigationController?.pushViewController(guest, animated: true)
        }
      })
    }
  }
  
  // 集合视图相关方法
  // 当用户点击单元格时……
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // 从uuidArray数组获取到当前所点击的帖子的uuid，并压入到全局数组postuuid中
    postuuid.append(uuidArray[indexPath.row])
    
    // 呈现PostVC控制器
    let post = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostVC
    self.navigationController?.pushViewController(post, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    
    let picImg = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
    cell.addSubview(picImg)
    
    picArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
      if error == nil {
        picImg.image = UIImage(data: data!)
      }else {
        print(error?.localizedDescription)
      }
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return picArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionViewLaunch() {
    // 集合视图的布局
    let layout = UICollectionViewFlowLayout()
    
    // 定义item的尺寸
    layout.itemSize = CGSize(width: self.view.frame.width / 3, height: self.view.frame.width / 3)
    
    // 设置滚动方向
    layout.scrollDirection = .vertical
    
    // 定义滚动视图在视图中的位置
    let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - self.tabBarController!.tabBar.frame.height - self.navigationController!.navigationBar.frame.height - 20)
    
    // 实例化滚动视图
    collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.alwaysBounceVertical = true
    collectionView.backgroundColor = .white
    
    self.view.addSubview(collectionView)
    
    // 定义集合视图中的单元格
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    
    // 载入帖子
    loadPosts()
  }
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y >= scrollView.contentSize.height / 6 {
      self.loadMore()
    }
  }
  
  func loadMore() {
    // 如果有更多的帖子需要载入
    if page <= picArray.count {
      // 增加page的数量
      page = page + 24
      
      // 载入更多的帖子
      let query = AVQuery(className: "Posts")
      query?.limit = page
      query?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
        if error == nil {
          // 清空数组
          self.picArray.removeAll(keepingCapacity: false)
          self.uuidArray.removeAll(keepingCapacity: false)
          
          // 获取相关数据
          for object in objects! {
            self.picArray.append(object.value(forKey: "pic") as! AVFile)
            self.uuidArray.append(object.value(forKey: "puuid") as! String)
          }
          self.collectionView.reloadData()
        }else {
          print(error?.localizedDescription)
        }
      })
    }
  }
  
  func loadPosts() {
    let query = AVQuery(className: "Posts")
    query?.limit = page
    query?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
      if error == nil {
        // 清空数组
        self.picArray.removeAll(keepingCapacity: false)
        self.uuidArray.removeAll(keepingCapacity: false)
        
        // 获取相关数据
        for object in objects! {
          self.picArray.append(object.value(forKey: "pic") as! AVFile)
          self.uuidArray.append(object.value(forKey: "puuid") as! String)
        }
        self.collectionView.reloadData()
      }else {
        print(error?.localizedDescription)
      }
    })
  }
}
