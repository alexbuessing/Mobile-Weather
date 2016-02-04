//
//  TemperatureView.swift
//  MobileWeather
//
//  Created by Alexander Buessing on 2/4/16.
//  Copyright © 2016 Buessing. All rights reserved.
//

import UIKit
import CoreLocation

let π: CGFloat = CGFloat(M_PI)

@IBDesignable class TemperatureView: UIView {

    var weather = Weather(latitude: 35.998, longitude: -78.453)
    
    override func awakeFromNib() {
        
    }
    
    @IBInspectable var barLineColor: UIColor = UIColor.whiteColor()
    
    override func drawRect(rect: CGRect) {
        
//        let tempMin = weather.firstDayMin
//        let tempMax = weather.firstDayMax
        let labelWidth: CGFloat = 50
        
        let barMaxLength: CGFloat = bounds.width - 2 * labelWidth
        
        //Left Arc
        let radius: CGFloat = 10
        let centerLeft = CGPoint(x: labelWidth + radius, y: bounds.height / 2)
        let arcWidth: CGFloat = 3
        let startAngle: CGFloat = 3/2 * π
        let endAngle: CGFloat = 1/2 * π
        
        let pathLeft = UIBezierPath(arcCenter: centerLeft, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        pathLeft.lineWidth = arcWidth
        barLineColor.setStroke()
        pathLeft.stroke()
        
        //Right Arc
        let centerRight = CGPoint(x: labelWidth + barMaxLength - radius, y: bounds.height / 2)
        
        let pathRight = UIBezierPath(arcCenter: centerRight, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        pathRight.lineWidth = arcWidth
        barLineColor.setStroke()
        pathRight.stroke()
        
        //Edges of Bar
        let edgeLine = UIBezierPath()
        
        edgeLine.lineWidth = arcWidth
        
        //Top of Bar
        edgeLine.moveToPoint(CGPoint(x: labelWidth + radius, y: bounds.height / 2 - radius))
        edgeLine.addLineToPoint(CGPoint(x: labelWidth + barMaxLength - radius, y: bounds.height / 2 - radius))
        
        //Bottom of Bar
        edgeLine.moveToPoint(CGPoint(x: labelWidth + radius, y: bounds.height / 2 + radius))
        edgeLine.addLineToPoint(CGPoint(x: labelWidth + barMaxLength - radius, y: bounds.height / 2 + radius))
        
        barLineColor.setStroke()
        edgeLine.stroke()
        
        
    }
    
}
