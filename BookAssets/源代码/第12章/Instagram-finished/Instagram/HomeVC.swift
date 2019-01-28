//
//  HomeVC.swift
//  Instagram
//
//  Created by 刘铭 on 16/7/9.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit
import LeanCloud

//private let reuseIdentifier = "Cell"

class HomeVC: UICollectionViewController {
    
    /*
     override func viewDidLoad() {
     super.viewDidLoad()
     
     // Uncomment the following line to preserve selection between presentations
     // self.clearsSelectionOnViewWillAppear = false
     
     // Register cell classes
     self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
     
     // Do any additional setup after loading the view.
     }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    
    /*
     override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
     
     // Configure the cell
     
     return cell
     }
     */
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        let header = self.collectionView?.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! HeaderView
        
        if let currentUser = LCUser.current {
            let email = currentUser.email // 当前用户的邮箱
            let username = currentUser.username // 当前用户名
            
            // 请注意，以下代码无法获取密码
            let password = currentUser.password
            
            let web = currentUser.web as? String
            let bio = currentUser.bio as? String
            print("email: \(String(describing: email?.value))")
            print("username: \(String(describing: username?.value))")
            print("password: \(String(describing: password?.value))")
            
            print("web: \(String(describing: web))")
            print("bio: \(String(describing: bio))")
//            email: Optional("a@qq.com")
//            username: Optional("a")
//            password: nil
//            web: nil
//            bio: nil
        }
        
        print("### collectionView ###")
        if let currentUser = LCUser.current {
            header.fullnameLbl.text = currentUser.fullname as? String
            header.webTxt.text = currentUser.web as? String
            header.webTxt.sizeToFit()
            header.bioLbl.text = currentUser.bio as? String
            header.bioLbl.sizeToFit()
            print("currentUser: \(currentUser)")
            let avaQuery = currentUser.ava as? LCFile
            
            // Value of optional type 'LCFile?' must be unwrapped to refer to member 'getDataInBackground' of wrapped base type 'LCFile'
            //avaQuery.getDataInBackground { (data:Data?, error:Error?) in
            //    header.avaImg.image = UIImage(data: data!)
           // }
            //Cast from 'LCFile?' to unrelated type 'Data' always fails
            print("avaQuery: \(avaQuery)")
            //header.avaImg.image = UIImage(data: avaQuery.payload?.dataValue as! Data)
            //print("avaQuery: \(avaQuery)")
            print("####")
            //}
            
            // LCUser.current!.fullname //object(forKey: "fullname") as? String)?.uppercased()
//            header.webTxt.text = LCUser.current!.object(forKey: "web") as? String
//            header.webTxt.sizeToFit()
//            header.bioLbl.text = LCUser.current!.object(forKey: "bio") as? String
//            header.bioLbl.sizeToFit()
//
//            let avaQuery = LCUser.current!.object(forKey: "ava") as! AVFile
//            avaQuery.getDataInBackground { (data:Data?, error:NSError?) in
//                header.avaImg.image = UIImage(data: data!)
//            }
        }
        
       
        
        return header
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: AnyObject?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: AnyObject?) {
     
     }
     */
    
}
