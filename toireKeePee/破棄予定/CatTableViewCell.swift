

import UIKit
import Haneke

class CatTableViewCell: UITableViewCell {

    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var catImageView: UIImageView!
    
    var cat: JSON? {
        didSet {
            self.setupCat()
        }
    }
    
    func setupCat() {
     self.captionLabel.text = self.cat?["caption"]["text"].string
        if let urlString = self.cat?["images"]["standard_resolution"]["url"] {
            let url = NSURL(string: urlString.stringValue)
            self.catImageView.hnk_setImageFromURL(url!)
        }
        
    }
    
}
