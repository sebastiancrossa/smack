//
//  CircleImage.swift
//  Smack
//
//  Created by Sebastian Crossa on 7/31/17.
//  Copyright © 2017 Sebastian Crossa. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImage: UIImageView {
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2 // It will turn into a perfect circle
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
}
