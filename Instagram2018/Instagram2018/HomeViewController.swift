//
//  HomeViewController.swift
//  Instagram2018
//
//  Created by coderdream on 2018/12/5.
//  Copyright © 2018 CoderDream. All rights reserved.
//

import UIKit
import LeanCloud

// private let reuseIdentifier = "Cell"

class HomeViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeViewController.viewDidLoad()")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("HomeViewController.collectionView(_:viewForSupplementaryElementOfKind)")
        let header = self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! HeaderReusableView
        let currentUser = LCUser.current!
        header.fullnameLbl.text =  currentUser.get("fullname")?.stringValue
        header.webTxt.text =  currentUser.get("web")?.stringValue // .username?.value // (currentUser.object(forKey: "fullname") as? String)?.uppercased()
    //header.webTxt.text = currentUser.web?.value // LCUser.current().object(forKey: "web") as? String
        header.webTxt.sizeToFit()
        header.bioLbl.text = currentUser.get("bio")?.stringValue //LCUser.current().object(forKey: "bio") as? String
        header.bioLbl.sizeToFit()
        print(header.fullnameLbl.text!)
        print(header.webTxt.text!)
        print(header.bioLbl.text!)
        let avaQuery = currentUser.get("bio")?.lcValue as? LCFile // AVUser.current().object(forKey: "ava") as! AVFile
        
        //avaQuery!.getDataInBackground { (data:Data?, error:NSError?) in
        header.avaImg.image = UIImage(data: (avaQuery?.dataValue)!)
       // }
        
        return header
    }
    

//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//
//        // Configure the cell
//
//        return cell
//    }

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

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
