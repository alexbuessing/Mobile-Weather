//
//  LocationCell.swift
//  MobileWeather
//
//  Created by Alexander Buessing on 1/28/16.
//  Copyright © 2016 Buessing. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet var locationLabel: UILabel!

    override func awakeFromNib() {
        layer.cornerRadius = 10.0
    }
    
    func configureCell(location: String) {
        locationLabel.text = location
    }
    
}
