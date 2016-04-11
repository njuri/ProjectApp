//
//  PhotoCollectionViewCell.swift
//  ProjectApp
//
//  Created by Juri Noga on 09.04.16.
//  Copyright © 2016 Juri Noga. All rights reserved.
//

import UIKit
import ParseUI

class PhotoCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var photoImageView: PFImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
