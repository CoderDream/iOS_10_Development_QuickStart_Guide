import UIKit
import AVOSCloud

class FollowersCell: UITableViewCell {
  
  @IBOutlet weak var avaImg: UIImageView!
  @IBOutlet weak var usernameLbl: UILabel!
  @IBOutlet weak var followBtn: UIButton!
  
  var user: AVUser!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    avaImg.layer.cornerRadius = avaImg.frame.width / 2
    avaImg.clipsToBounds = true
  }
  
  @IBAction func followBtn_click(_ sender: AnyObject) {
    let title = followBtn.title(for: .normal)
    
    if title == "关 注" {
      guard user != nil else { return }
      
      AVUser.current().follow(user.objectId, andCallback: { (success:Bool, error:NSError?) in
        if success {
          self.followBtn.setTitle("√ 已关注", for: .normal)
          self.followBtn.backgroundColor = .green()
        }else {
          print(error?.localizedDescription)
        }
      })
    } else {
      guard user != nil else { return }
      
      AVUser.current().unfollow(user.objectId, andCallback: { (success:Bool, error:NSError?) in
        if success {
          self.followBtn.setTitle("关 注", for: .normal)
          self.followBtn.backgroundColor = .lightGray()
        }else {
          print(error?.localizedDescription)
        }
      })
    }
  }
  
  
}
