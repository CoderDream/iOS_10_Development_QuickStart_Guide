//
//  PictureCell.swift
//  Instagram
//
//  Created by 刘铭 on 16/7/9.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell {
  @IBOutlet weak var picImg: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    let width = UIScreen.main().bounds.width
    
    picImg.frame = CGRect(x: 0, y: 0, width: width / 3, height: width / 3)
  }
}
