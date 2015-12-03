//
//  AboutTableViewCell.swift
//  toireKeePee
//
//  Created by nk on 2015/12/01.
//  Copyright © 2015年 hattori. All rights reserved.
//

import UIKit

class AboutTableViewCell: UITableViewCell {

    @IBOutlet weak var versionLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // versionLabelを表示
        let infoDictionary = NSBundle.mainBundle().infoDictionary! as Dictionary
        let CFBundleShortVersionString = infoDictionary["CFBundleShortVersionString"]! as! String
        versionLabel.text = "Ver.\(CFBundleShortVersionString)"
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
