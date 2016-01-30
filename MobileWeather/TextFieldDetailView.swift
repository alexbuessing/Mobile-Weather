//
//  TextFieldDetailView.swift
//  MobileWeather
//
//  Created by Alexander Buessing on 1/28/16.
//  Copyright © 2016 Buessing. All rights reserved.
//

import UIKit

class TextFieldDetailView: UITextField {

    override func awakeFromNib() {
        
        layer.cornerRadius = self.frame.height / 2
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(red: 155.0 / 255.0, green: 155.0 / 255.0, blue: 155.0 / 255.0, alpha: 0.5).CGColor
    }

    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(CGRect(x: 0.0, y: 0.0, width: bounds.width - 10.0, height: bounds.height), 15.0, 0.0)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(CGRect(x: 0.0, y: 0.0, width: bounds.width - 10.0, height: bounds.height), 15.0, 0.0)
    }
    
}
