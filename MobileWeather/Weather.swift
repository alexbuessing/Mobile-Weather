//
//  Weather.swift
//  MobileWeather
//
//  Created by Alexander Buessing on 1/22/16.
//  Copyright © 2016 Buessing. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class Weather {
    
    private var _sunrise: String!
    private var _sunset: String!
    private var _latitude: CLLocationDegrees!
    private var _longitude: CLLocationDegrees!
    private var _location: String!
    private var _weatherURL: String!
    private var _tempMin: String!
    private var _tempMax: String!
    private var _currentTemp: String!
    private var _humidity: String!
    private var _windSpeed: String!
    private var _temperatureArray: Array<String>!
    private var _hourlyArray: Array<String>!
    private var _iconArray: Array<String>!
    private var _todayIcon: String!
    private var _bgImg: UIImage!
    
    var timer = NSTimer()
    
    var bgImg: UIImage {
        if _bgImg == nil {
            _bgImg = UIImage(named: "1")
        }
        return _bgImg
    }
    
    var weatherURL: String {
        get {
            return _weatherURL
        } set (newVal) {
            _weatherURL = newVal
        }
    }
    
    var location: String {
        get {
            if _location == nil {
                _location = ""
            }
            return _location
        } set (newVal) {
            _location = newVal
        }
    }
    
    var todayIcon: String {
        if _todayIcon == nil {
            _todayIcon = "clear-day"
        }
        return _todayIcon
    }
    
    var iconArray: Array<String> {
        if _iconArray == nil {
            _iconArray = ["clear-day"]
        }
        return _iconArray
    }
    
    var hourlyArray: Array<String> {
        if _hourlyArray == nil {
            _hourlyArray = ["12AM"]
        }
        return _hourlyArray
    }
    
    var temperatureArray: Array<String> {
        if _temperatureArray == nil {
            _temperatureArray = ["0"]
        }
        return _temperatureArray
    }
    
    var humidity: String {
        if _humidity == nil {
            _humidity = "0.0"
        }
        return _humidity
    }
    
    var windSpeed: String {
        if _windSpeed == nil {
            _windSpeed = "0.0"
        }
        return _windSpeed
    }
    
    var tempMin: String {
        if _tempMin == nil {
            _tempMin = "32.0"
        }
        return _tempMin
    }
    
    var tempMax: String {
        if _tempMax == nil {
            _tempMax = "72.0"
        }
        return _tempMax
    }
    
    var currentTemp: String {
        if _currentTemp == nil {
            _currentTemp = "60.0"
        }
        return _currentTemp
    }
    
    var sunrise: String {
        if _sunrise == nil {
            _sunrise = ""
        }
        return _sunrise
    }
    
    var sunset: String {
        if _sunset == nil {
            _sunset = ""
        }
        return _sunset
    }
    
    var latitude: CLLocationDegrees {
        get {
            return _latitude
        } set (newValue) {
            _latitude = newValue
        }
    }
    
    var longitude: CLLocationDegrees {
        get {
            return _longitude
        } set (newValue) {
            _longitude = newValue
        }
    }
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        _latitude = latitude
        _longitude = longitude
        _weatherURL = "\(BASE_URL)\(latitude),\(longitude)"
        
    }
    
    func getImageNumber(condition: String) -> Int {
        
        switch condition {
            case "snow":
            return 9
            case "cloudy":
            return 14
            case "partly-cloudy-night":
            return 8
            case "partly-cloudy-day":
            return 7
            case "clear-day":
            return 1
            case "clear-night":
            return 2
            case "rain":
            return 3
            case "sleet":
            return 13
            case "wind":
            return 10
            case "fog":
            return 5
        default:
            return 1
        
        }
    }
    
    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees, label: UILabel) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            else if placemarks?.count > 0 {
                let pm = placemarks![0]
                label.text = "\(pm.subAdministrativeArea!), \(pm.administrativeArea!)"
            }
        })
        
    }
    
    func startTime() {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "getTimeAndDay", userInfo: nil, repeats: true)
        
    }
    
    func getTimeAndDay() -> String {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .FullStyle
        let dayArr = String(formatter.stringFromDate(date)).componentsSeparatedByString(" ")
        let day = dayArr[0].stringByReplacingOccurrencesOfString(",", withString: "")
        let date2 = NSDate()
        let formatter2 = NSDateFormatter()
        formatter2.timeStyle = .FullStyle
        var fullTime = String(formatter2.stringFromDate(date2)).componentsSeparatedByString(" ")
        let morningAfternoon = fullTime[1]
        let time = String(fullTime[0].characters.dropLast(3))
        return "\(time) \(morningAfternoon) \(day)"
    }
    
    func parseTime(time: String) -> Array<String> {
        
        var arrayContainer = time.componentsSeparatedByString(":")
        arrayContainer.append(arrayContainer[1].componentsSeparatedByString(" ")[0])
        let testArray = time.componentsSeparatedByString(" ")
        arrayContainer.removeAtIndex(1)
        arrayContainer.append(testArray[1])
        
        return arrayContainer
    }
    
    func isDaytime() -> Bool {
        
        let str = getTimeAndDay()
        var strArr = str.componentsSeparatedByString(" ")
        var currentTime = strArr[0].componentsSeparatedByString(":")
        currentTime.append(strArr[1])
        
        var sunriseArr = parseTime(_sunrise)
        var sunsetArr = parseTime(_sunset)
        
        if Int(currentTime[0])! == 12 && currentTime[2] == "PM" {
            return true
        } else if Int(currentTime[0])! == 12 && currentTime[2] == "AM" {
            
            return false
            
        } else if (Int(currentTime[0])! >= Int(sunriseArr[0])! && currentTime[2] == sunriseArr[2]) {
            
            if (Int(currentTime[0])! == Int(sunriseArr[0])!) {
                
                if Int(currentTime[1])! > Int(sunriseArr[1])! {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        } else if (Int(currentTime[0])! <= Int(sunsetArr[0])! && currentTime[2] == sunsetArr[2]) {
            
            if (Int(currentTime[0])! == Int(sunsetArr[0])!) {
                
                if Int(currentTime[1])! < Int(sunsetArr[1])! {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    func getImage(condition: String) {
        
        var image1: UIImage!
        
        switch condition {
        case "thunderstorm":
            if isDaytime() == true {
                image1 = UIImage(named: "thunderstormbg.jpg")
            } else {
                image1 = UIImage(named: "thunderstormnightbg.jpg")
            }
        case "rain":
            if isDaytime() == true {
                image1 = UIImage(named: "rainbg.jpg")
            } else {
                image1 = UIImage(named: "nightrainbg.jpg")
            }
        case "snow":
            if isDaytime() == true {
                image1 = UIImage(named: "snowbg.jpg")
            } else {
                image1 = UIImage(named: "snowbg.jpg")
            }
        case "sleet":
            if isDaytime() == true {
                image1 = UIImage(named: "snowbg.jpg")
            } else {
                image1 = UIImage(named: "snowbg.jpg")
            }
        case "fog":
            if isDaytime() == true {
                image1 = UIImage(named: "hazebg.jpg")
            } else {
                image1 = UIImage(named: "hazenightbg.jpg")
            }
        case "clear-day":
            if isDaytime() == true {
                image1 = UIImage(named: "sunbg.jpg")
            } else {
                image1 = UIImage(named: "clearnightbg.jpg")
            }
        case "clear-night":
            if isDaytime() == true {
                image1 = UIImage(named: "sunbg.jpg")
            } else {
                image1 = UIImage(named: "clearnightbg.jpg")
            }
        case "cloudy":
            if isDaytime() == true {
                image1 = UIImage(named: "cloudybg.jpg")
            } else {
                image1 = UIImage(named: "cloudynightbg.jpg")
            }
        case "partly-cloudy-day":
            if isDaytime() == true {
                image1 = UIImage(named: "partlyCloudybg.jpg")
            } else {
                image1 = UIImage(named: "cloudynightbg.jpg")
            }
        case "partly-cloudy-night":
            if isDaytime() == true {
                image1 = UIImage(named: "partlyCloudybg.jpg")
            } else {
                image1 = UIImage(named: "cloudynightbg.jpg")
            }
        case "wind":
            image1 = UIImage(named: "windybg.jpg")
        default:
            if isDaytime() == true {
                image1 = UIImage(named: "sunbg.jpg")
            } else {
                image1 = UIImage(named: "clearnightbg.jpg")
            }
        }
        
        _bgImg = image1
        
    }
    
    func kelvinToFarenheit(kelvin: String) -> String {
        
        var farenheit: Double
        farenheit = round((Double(kelvin)! - 273.15) * 1.8 + 32)
        
        return NSString(format: "%.0f", farenheit) as String
    }
    
    func downloadWeatherDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _weatherURL)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let hourly = dict["hourly"] as? Dictionary<String, AnyObject> {
                    
                    if let data = hourly["data"] as? [Dictionary<String, AnyObject>] where data.count > 0 {
                        
                        var iconsArray = Array<String>()
                        for var x = 0; x < 24; x++ {
                            if let iconInfo = data[x]["icon"] as? String {
                                iconsArray.append(iconInfo)
                            }
                        }
                        self._iconArray = iconsArray
                        iconsArray = []
                        
                        var hourArray = Array<String>()
                        for var x = 0; x < 24; x++ {
                            if let hourInfo = data[x]["time"] as? Double {
                                let date = NSDate(timeIntervalSince1970: hourInfo)
                                let timeFormatter = NSDateFormatter()
                                timeFormatter.dateFormat = "ha"
                                hourArray.append(timeFormatter.stringFromDate(date))
                            }
                        }
                        self._hourlyArray = hourArray
                        hourArray = []
                        
                        var tempArray = Array<String>()
                        for var x = 0; x < 24; x++ {
                            if let tempInfo = data[x]["temperature"] as? Double {
                                tempArray.append(NSString(format: "%.0f", tempInfo) as String)
                            }
                        }
                        self._temperatureArray = tempArray
                        tempArray = []
                    }
                    
                }
                
                if let current = dict["currently"] as? Dictionary<String, AnyObject> {
                    
                    if let temp = current["temperature"] as? Double {
                        self._currentTemp = NSString(format: "%.0f", temp) as String
                    }
                    
                    if let icon = current["icon"] as? String {
                        self._todayIcon = icon
                    }
                    
                    if let humid = current["humidity"] as? Double {
                        self._humidity = NSString(format: "%0.f", humid) as String
                    }
                    
                    if let winds = current["windSpeed"] as? Double {
                        self._windSpeed = NSString(format: "%.0f", winds) as String
                    }
                    
                }
                
                if let today = dict["daily"] as? Dictionary<String, AnyObject> {
                    
                    if let data = today["data"] as? [Dictionary<String, AnyObject>] where data.count > 0 {
                        
                        //clear-day, clear-night, rain, snow, sleet, wind, fog, cloudy, partly-cloudy-day, or partly-cloudy-night.
                        
                        if let tempsMin = data[0]["temperatureMin"] as? Double {
                            self._tempMin = NSString(format: "%.0f", tempsMin) as String
                        }
                        
                        if let tempsMax = data[0]["temperatureMax"] as? Double {
                            self._tempMax = NSString(format: "%.0f", tempsMax) as String
                        }
                        
                        if let sunriseTime = data[0]["sunriseTime"] as? Double {
                            let date = NSDate(timeIntervalSince1970: sunriseTime)
                            let timeFormatter = NSDateFormatter()
                            timeFormatter.dateFormat = "h:mm a"
                            self._sunrise = timeFormatter.stringFromDate(date)
                            
                        }
                        
                        if let sunsetTime = data[0]["sunsetTime"] as? Double {
                            let date = NSDate(timeIntervalSince1970: sunsetTime)
                            let timeFormatter = NSDateFormatter()
                            timeFormatter.dateFormat = "h:mm a"
                            self._sunset = timeFormatter.stringFromDate(date)
                        }
                        
                    }
                    
                }
                
            }
         completed()
        }
        
    }
    
}
