//
//  ButtonDetailView.swift
//  MobileWeather
//
//  Created by Alexander Buessing on 1/28/16.
//  Copyright © 2016 Buessing. All rights reserved.
//

import UIKit

class ButtonDetailView: UIButton {

    override func awakeFromNib() {
        
        layer.cornerRadius = self.frame.height / 2
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(red: 155.0 / 255.0, green: 155.0 / 255.0, blue: 155.0 / 255.0, alpha: 0.5).CGColor
        layer.backgroundColor = UIColor(red: 48.0 / 255.0, green: 63.0 / 255.0, blue: 159.0 / 255.0, alpha: 1.0).CGColor
        
    }
}
