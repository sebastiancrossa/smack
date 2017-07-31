//
//  AvatarCell.swift
//  Smack
//
//  Created by Sebastian Crossa on 7/31/17.
//  Copyright © 2017 Sebastian Crossa. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView() {
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
}
