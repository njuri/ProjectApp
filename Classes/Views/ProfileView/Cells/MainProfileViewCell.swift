//
//  MainProfileViewCell.swift
//  ProjectApp
//
//  Created by Juri Noga on 09.04.16.
//  Copyright © 2016 Juri Noga. All rights reserved.
//

import UIKit
import ParseUI

class MainProfileViewCell: UITableViewCell {

  @IBOutlet weak var profileImageView: PFImageView!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var userNameField: UITextField!
  
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
