//
//  HomeVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/7/9.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import AVOSCloud

class HomeVC: UICollectionViewController {

  // 刷新控件
  var refresher: UIRefreshControl!
  
  // 每页载入帖子（图片）的数量
  var page: Int = 10
  
  var uuidArray = [String]()
  var picArray = [AVFile]()
  
    override func viewDidLoad() {
        super.viewDidLoad()

      self.navigationItem.title = AVUser.current().username.uppercased()
      
      // 设置refresher控件到集合视图之中
      refresher = UIRefreshControl()
      refresher.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
      collectionView?.addSubview(refresher)
      
      loadPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
  
  func refresh() {
    collectionView?.reloadData()
    
    // 停止刷新动画
    refresher.endRefreshing()
  }
  
  func loadPosts() {
    let query = AVQuery(className: "Posts")
    query?.whereKey("username", equalTo: AVUser.current().username)
    query?.limit = page
    query?.findObjectsInBackground({ (objects:[AnyObject]?, error:NSError?) in
      // 查询成功
      if error == nil {
        // 清空两个数组
        self.uuidArray.removeAll(keepingCapacity: false)
        self.picArray.removeAll(keepingCapacity: false)
        
        for object in objects! {
          // 将查询到的数据添加到数组中
          self.uuidArray.append(object.value(forKey: "uuid") as! String)
          self.picArray.append(object.value(forKey: "pic") as! AVFile)
        }
        
        self.collectionView?.reloadData()
      }else {
        print(error?.localizedDescription)
      }
    })
  }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return picArray.count
    }

  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! HeaderView
    
    header.fullnameLbl.text = (AVUser.current().object(forKey: "fullname") as? String)?.uppercased()
    header.webTxt.text = AVUser.current().object(forKey: "web") as? String
    header.webTxt.sizeToFit()
    header.bioLbl.text = AVUser.current().object(forKey: "bio") as? String
    header.bioLbl.sizeToFit()
    
    let avaQuery = AVUser.current().object(forKey: "ava") as! AVFile
    avaQuery.getDataInBackground { (data:Data?, error:NSError?) in
      header.avaImg.image = UIImage(data: data!)
    }
    
    return header
  }
  
  
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
      // 从集合视图的可复用队列中获取单元格对象
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PictureCell
      
      // 从picArray数组中获取图片
      picArray[indexPath.row].getDataInBackground { (data:Data?, error:NSError?) in
        if error == nil {
          cell.picImg.image = UIImage(data: data!)
        }else{
          print(error?.localizedDescription)
        }
      }
      
      return cell
    }
 

  

}
