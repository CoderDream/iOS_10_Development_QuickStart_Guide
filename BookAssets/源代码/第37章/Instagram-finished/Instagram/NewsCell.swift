//
//  NewsCell.swift
//  Instagram
//
//  Created by 刘铭 on 16/8/14.
//  Copyright © 2016年 刘铭. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
  
  @IBOutlet weak var avaImg: UIImageView!
  @IBOutlet weak var usernameBtn: UIButton!
  @IBOutlet weak var infoLbl: UILabel!
  @IBOutlet weak var dateLbl: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // 约束
    avaImg.translatesAutoresizingMaskIntoConstraints = false
    usernameBtn.translatesAutoresizingMaskIntoConstraints = false
    infoLbl.translatesAutoresizingMaskIntoConstraints = false
    dateLbl.translatesAutoresizingMaskIntoConstraints = false
    
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[ava(30)]-10-[username]-7-[info]-10-[date]", options: [], metrics: nil, views: ["ava": avaImg, "username": usernameBtn, "info": infoLbl, "date": dateLbl]))
    
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[ava(30)]-10-|", options: [], metrics: nil, views: ["ava": avaImg]))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[username(30)]", options: [], metrics: nil, views: ["username": usernameBtn]))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[info(30)]", options: [], metrics: nil, views: ["info": infoLbl]))
    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[date(30)]", options: [], metrics: nil, views: ["date": dateLbl]))
    
    // 头像变圆
    self.avaImg.layer.cornerRadius = avaImg.frame.width / 2
    self.avaImg.clipsToBounds = true
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
