//
//  ProfileTableViewCell.swift
//  Drag and Drop
//
//  Created by Andrei Movila on 6/13/17.
//  Copyright © 2017 Andrei Movila. All rights reserved.
//

import UIKit
import SDWebImage
class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = 40
        profileImage.layer.borderWidth = 1
        profileImage.clipsToBounds = true
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupWithProfileModel(model:ProfileModel)
    {
        let attrStr = NSMutableAttributedString(string: model.title + "\n\n" + model.subtitle)
        attrStr.addAttribute(NSAttributedStringKey.font,
                             value: UIFont(name: "Chalkduster", size: 12)!,
                             range: NSMakeRange(model.title.count + 2, model.subtitle.count))
        infoLabel.attributedText = attrStr;
        profileImage.sd_setImage(with : model.imageUrl) { (image, error, cacheType, url) in
            if (image != nil) == false {
                self.profileImage.image = model.image
            }
        }
        
    }
}

