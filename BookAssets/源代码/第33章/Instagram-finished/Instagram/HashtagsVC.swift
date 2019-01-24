//
//  HashtagsVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/8/10.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

var hashtag = [String]()

class HashtagsVC: UICollectionViewController,UICollectionViewDelegateFlowLayout {
  
  // UI objects
  var refresher: UIRefreshControl!
  var page: Int = 24
  
  // 从云端获取记录后，存储数据的数组
  var picArray = [AVFile]()
  var uuidArray = [String]()
  var filterArray = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.collectionView?.alwaysBounceVertical = true
    self.navigationItem.title = "#" + "\(hashtag.last!.uppercased())"
    
    // 定义导航栏中新的返回按钮
    self.navigationItem.hidesBackButton = true
    //let backBtn = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back(_:)))
    let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: .plain, target: self, action: #selector(back(_:)))
    self.navigationItem.leftBarButtonItem = backBtn
    
    
    // 实现向右划动返回
    let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back(_:)))
    backSwipe.direction = .right
    self.view.addGestureRecognizer(backSwipe)
    
    // 安装refresh控件
    refresher = UIRefreshControl()
    refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
    self.collectionView?.addSubview(refresher)
    
    loadHashtags()
  }
  
  func back(_: UIBarButtonItem) {
    // 退回到之前的控制器
    _ = self.navigationController?.popViewController(animated: true)
    
    // 从hashtag数组中移除最后一个主题标签
    if !hashtag.isEmpty {
      hashtag.removeLast()
    }
  }
  
  // 刷新方法
  func refresh() {
    loadHashtags()
  }

  // 载入hashtag
  func loadHashtags() {
    // STEP 1. 获取与Hashtag相关的帖子
    let hashtagQuery = AVQuery(className: "Hashtags")
    hashtagQuery?.whereKey("hashtag", equalTo: hashtag.last!)
    hashtagQuery?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
      if error == nil {
        // 清空 filterArray 数组
        self.filterArray.removeAll(keepingCapacity: false)
        
        // 存储相关的帖子到filterArray数组
        for object in objects! {
          self.filterArray.append(object.value(forKey: "to") as! String)
        }
        
        // STEP 2. 通过filterArray的uuid，找出相关的帖子
        let query = AVQuery(className: "Posts")
        query?.whereKey("puuid", containedIn: self.filterArray)
        query?.limit = self.page
        query?.addDescendingOrder("createdAt")
        query?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
          if error == nil {
            // 清空数组
            self.picArray.removeAll(keepingCapacity: false)
            self.uuidArray.removeAll(keepingCapacity: false)
            
            for object in objects! {
              self.picArray.append(object.value(forKey: "pic") as! AVFile)
              self.uuidArray.append(object.value(forKey: "puuid") as! String)
            }
            
            // reload
            self.collectionView?.reloadData()
            self.refresher.endRefreshing()
          }else {
            print(error?.localizedDescription)
          }
        })
      }else {
        print(error?.localizedDescription)
      }
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: UICollectionViewDataSource
  
  // 设置单元格大小
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let size = CGSize(width: self.view.frame.width / 3, height: self.view.frame.width / 3)
    return size
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return picArray.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // 从集合视图的可复用队列中获取单元格对象
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PictureCell
    
    // 从picArray数组中获取图片
    picArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
      if error == nil {
        cell.picImg.image = UIImage(data: data!)
      }else{
        print(error?.localizedDescription)
      }
    }
    
    return cell
  }
  
  // go post
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // 发送post uuid 到 postuuid数组中
    postuuid.append(uuidArray[indexPath.row])
    
    // 导航到postVC控制器
    let postVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostVC
    self.navigationController?.pushViewController(postVC, animated: true)
  }

  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y >= scrollView.contentSize.height / 3 {
      loadMore()
    }
  }
  
  // 用于分页
  func loadMore() {
    // 如果服务器端的帖子大于默认显示数量
    if page <= uuidArray.count {
      page = page + 15
      // STEP 1. 获取与Hashtag相关的帖子
      let hashtagQuery = AVQuery(className: "Hashtags")
      hashtagQuery?.whereKey("hashtag", equalTo: hashtag.last!)
      hashtagQuery?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
        if error == nil {
          // 清空 filterArray 数组
          self.filterArray.removeAll(keepingCapacity: false)
          
          // 存储相关的帖子到filterArray数组
          for object in objects! {
            self.filterArray.append(object.value(forKey: "to") as! String)
          }
          
          // STEP 2. 通过filterArray的uuid，找出相关的帖子
          let query = AVQuery(className: "Posts")
          query?.whereKey("puuid", containedIn: self.filterArray)
          query?.limit = self.page
          query?.addDescendingOrder("createdAt")
          query?.findObjectsInBackground({ (objects:[AnyObject]?, error:Error?) in
            if error == nil {
              // 清空数组
              self.picArray.removeAll(keepingCapacity: false)
              self.uuidArray.removeAll(keepingCapacity: false)
              
              for object in objects! {
                self.picArray.append(object.value(forKey: "pic") as! AVFile)
                self.uuidArray.append(object.value(forKey: "puuid") as! String)
              }
              
              // reload
              self.collectionView?.reloadData()
            }else {
              print(error?.localizedDescription)
            }
          })
        }else {
          print(error?.localizedDescription)
        }
      })
    }
  }
  
}
