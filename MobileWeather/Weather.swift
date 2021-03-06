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
import SystemConfiguration

class Weather {
    
    private var _sunrise: String!
    private var _sunset: String!
    private var _latitude: CLLocationDegrees!
    private var _longitude: CLLocationDegrees!
    private var _location: String!
    private var _weatherURL: String!
    private var _currentTemp: String!
    private var _humidity: String!
    private var _windSpeed: String!
    private var _temperatureArray: Array<String>!
    private var _hourlyArray: Array<String>!
    private var _iconArray: Array<String>!
    private var _todayIcon: String!
    private var _bgImg: UIImage!
    private var _summary: String!
    private var _firstDayLbl: String!
    private var _secondDayLbl: String!
    private var _thirdDayLbl: String!
    private var _fourthDayLbl: String!
    private var _fifthDayLbl: String!
    private var _currentDayLbl: String!
    private var _firstDayIcon: String!
    private var _secondDayIcon: String!
    private var _thirdDayIcon: String!
    private var _fourthDayIcon: String!
    private var _fifthDayIcon: String!
    private var _forecastIconArray: Array<String>!
    private var _tempMinArr: Array<String>!
    private var _tempMaxArr: Array<String>!
    
    var dayCounter: Int = 0
    
    var tempMinArr: Array<String> {
        if _tempMinArr == nil {
            _tempMinArr = ["0º","0º","0º","0º","0º","0º"]
        }
        return _tempMinArr
    }
    
    var tempMaxArr: Array<String> {
        if _tempMaxArr == nil {
            _tempMaxArr = ["32º","32º","32º","32º","32º","32º"]
        }
        return _tempMaxArr
    }
    
    var forecastIconArray: Array<String> {
        if _forecastIconArray == nil {
            _forecastIconArray = ["clear-day","clear-day","clear-day","clear-day","clear-day"]
        }
        return _forecastIconArray
    }
    
    var currentDayLbl: String {
        if _currentDayLbl == nil {
            _currentDayLbl = ""
        }
        return _currentDayLbl
    }
    
    var firstDayLbl: String {
        if _firstDayLbl == nil {
            _firstDayLbl = ""
        }
        return _firstDayLbl
    }
    
    var secondDayLbl: String {
        if _secondDayLbl == nil {
            _secondDayLbl = ""
        }
        return _secondDayLbl
    }
    
    var thirdDayLbl: String {
        if _thirdDayLbl == nil {
            _thirdDayLbl = ""
        }
        return _thirdDayLbl
    }
    
    var fourthDayLbl: String {
        if _fourthDayLbl == nil {
            _fourthDayLbl = ""
        }
        return _fourthDayLbl
    }
    
    var fifthDayLbl: String {
        if _fifthDayLbl == nil {
            _fifthDayLbl = ""
        }
        return _fifthDayLbl
    }
    
    var summary: String {
        if _summary == nil {
            _summary = ""
        }
        return _summary
    }
    
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
    
    var currentTemp: String {
        if _currentTemp == nil {
            _currentTemp = "60.0"
        }
        return _currentTemp
    }
    
    var sunrise: String {
        if _sunrise == nil {
            _sunrise = "7:00 AM"
        }
        return _sunrise
    }
    
    var sunset: String {
        if _sunset == nil {
            _sunset = "6:00 PM"
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
        
        self._currentDayLbl = currentDay()
        
        switch _currentDayLbl {
        case "Sunday":
            dayCounter = 1
        case "Monday":
            dayCounter = 2
        case "Tuesday":
            dayCounter = 3
        case "Wednesday":
            dayCounter = 4
        case "Thursday":
            dayCounter = 5
        case "Friday":
            dayCounter = 6
        case "Saturday":
            dayCounter = 7
        default:
            dayCounter = 1
            
        }
        
        self._firstDayLbl = daysOfTheWeek[getCorrectDay(1)]
        self._secondDayLbl = daysOfTheWeek[getCorrectDay(2)]
        self._thirdDayLbl = daysOfTheWeek[getCorrectDay(3)]
        self._fourthDayLbl = daysOfTheWeek[getCorrectDay(4)]
        self._fifthDayLbl = daysOfTheWeek[getCorrectDay(5)]
        
    }
    
    func getCorrectDay(day: Int) -> Int {
        var result: Int!
        if dayCounter + day <= 7 {
            result = dayCounter + day
        } else {
            result = (dayCounter + day - 7)
        }
        return result
    }
    
    func currentDay() -> String {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .FullStyle
        formatter.stringFromDate(date)
        let dayArr = String(formatter.stringFromDate(date)).componentsSeparatedByString(",")
        return dayArr[0]
    }
    
    //-----------------------------------------------------------------------------------------
    
    
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
    
    
    //-----------------------------------------------------------------------------------------
    
    
    //Gets users city and state based off coordinates
    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees, label: UILabel) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            else if placemarks?.count > 0 {
                let pm = placemarks![0]
                label.text = "\(pm.locality!), \(pm.administrativeArea!)"
            }
        })
        
    }
    
    
    //-----------------------------------------------------------------------------------------
    
    
    //Tells weather the current time is between sunrise and sunset or between sunset and sunrise
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
    
    
    //-----------------------------------------------------------------------------------------
    
    
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
            image1 = UIImage(named: "sleetbg.jpg")
        case "fog":
            if isDaytime() == true {
                image1 = UIImage(named: "hazebg.jpg")
            } else {
                image1 = UIImage(named: "hazenightbg.jpg")
            }
        case "clear-day", "clear-night":
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
        case "partly-cloudy-day", "partly-cloudy-night":
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
    
    
    //-----------------------------------------------------------------------------------------
    
    
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        return (isReachable && !needsConnection)
    }
    
    
    //-----------------------------------------------------------------------------------------
    
    
    func downloadWeatherDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _weatherURL)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let hourly = dict["hourly"] as? Dictionary<String, AnyObject> {
                    
                    if let summary = hourly["summary"] as? String {
                        self._summary = summary
                    }
                    
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
                        let hum = humid * 100
                        self._humidity = NSString(format: "%0.f", hum) as String
                    }
                    
                    if let winds = current["windSpeed"] as? Double {
                        self._windSpeed = NSString(format: "%.0f", winds) as String
                    }
                    
                }
                
                if let today = dict["daily"] as? Dictionary<String, AnyObject> {
                    
                    if let data = today["data"] as? [Dictionary<String, AnyObject>] where data.count > 0 {
                        
                        //clear-day, clear-night, rain, snow, sleet, wind, fog, cloudy, partly-cloudy-day, or partly-cloudy-night.
                        var tempArr = Array<String>()
                        for var x = 1; x <= 5; x++ {
                            if let forecastIcon = data[x]["icon"] as? String {
                                tempArr.append(forecastIcon)
                            }
                        }
                        self._forecastIconArray = tempArr
                        tempArr = []
                        
                        for var x = 0; x <= 5; x++ {
                            if let minTemps = data[x]["temperatureMin"] as? Double {
                                tempArr.append(NSString(format: "%.0f", minTemps) as String)
                            }
                        }
                        self._tempMinArr = tempArr
                        tempArr = []
                        
                        for var x = 0; x <= 5; x++ {
                            if let maxTemps = data[x]["temperatureMax"] as? Double {
                                tempArr.append(NSString(format: "%.0f", maxTemps) as String)
                            }
                        }
                        self._tempMaxArr = tempArr
                        tempArr = []
                        
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
