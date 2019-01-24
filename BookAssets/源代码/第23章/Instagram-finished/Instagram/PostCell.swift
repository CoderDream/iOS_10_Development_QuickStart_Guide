//
//  PostCell.swift
//  Instagram
//
//  Created by 刘铭 on 16/8/2.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
  
  @IBOutlet weak var avaImg: UIImageView!
  @IBOutlet weak var usernameBtn: UIButton!
  @IBOutlet weak var dateLbl: UILabel!
  
  // 帖子照片
  @IBOutlet weak var picImg: UIImageView!
  
  // 按钮
  @IBOutlet weak var likeBtn: UIButton!
  @IBOutlet weak var commentBtn: UIButton!
  @IBOutlet weak var moreBtn: UIButton!
  
  // Labels
  @IBOutlet weak var likeLbl: UILabel!
  @IBOutlet weak var titleLbl: UILabel!
  @IBOutlet weak var puuidLbl: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
