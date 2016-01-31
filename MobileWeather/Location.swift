//
//  Location.swift
//  MobileWeather
//
//  Created by Alexander Buessing on 1/30/16.
//  Copyright © 2016 Buessing. All rights reserved.
//

import UIKit

class Location {
    
    private var _locationName: String!
    private var _latitude: Double!
    private var _longitude: Double!
    private var _useSearchLocation: Bool!
    
    var useSearchLocation: Bool {
        get {
            if _useSearchLocation == nil {
                _useSearchLocation = false
            }
            return _useSearchLocation
        } set (newVal) {
            _useSearchLocation = newVal
        }
    }
    
    var locationName: String {
        get {
            if _locationName == nil {
                _locationName = ""
            }
            return _locationName
        } set (newVal) {
            _locationName = newVal
        }
    }
    
    var latitude: Double {
        get {
            if _latitude == nil {
                _latitude = 41.0
            }
            return _latitude
        } set (newVal) {
            _latitude = newVal
        }
    }
    
    var longitude: Double {
        get {
            if _longitude == nil {
                _longitude = -65.0
            }
            return _longitude
        } set (newVal) {
            _longitude = newVal
        }
    }

    init(){}
    
}










