//
//  SignInVC.swift
//  Instagram
//
//  Created by coderdream on 2018/12/2.
//  Copyright © 2018 coderdream. All rights reserved.
//

import UIKit

class SignInVC: UITableViewCell {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
