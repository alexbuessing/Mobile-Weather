//
//  Constants.swift
//  MobileWeather
//
//  Created by Alexander Buessing on 1/22/16.
//  Copyright © 2016 Buessing. All rights reserved.
//

import UIKit

let BASE_URL = "https://api.forecast.io/forecast/95daaab03d5219f345c111f7cbc9c693/"

let WIDTH: CGFloat = 75
let HEIGHT: CGFloat = 50
let LBL_HEIGHT: CGFloat = 20

let daysOfTheWeek = [1: "Sunday", 2: "Monday", 3: "Tuesday", 4: "Wednesday", 5: "Thursday", 6: "Friday", 7: "Saturday"]

typealias DownloadComplete = () -> ()
