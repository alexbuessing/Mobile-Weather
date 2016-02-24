//
//  ViewController.swift
//  MobileWeather
//
//  Created by Alexander Buessing on 1/21/16.
//  Copyright © 2016 Buessing. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI
import Contacts
import MBProgressHUD
import SystemConfiguration

class MainVC: UIViewController, CLLocationManagerDelegate, UIScrollViewDelegate, UIApplicationDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var timeDay: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var mainImg: UIImageView!
    @IBOutlet var mainImgView: UIView!
    @IBOutlet var detailsView: UIView!
    @IBOutlet var todayLow: UILabel!
    @IBOutlet var todayHigh: UILabel!
    @IBOutlet var humidity: UILabel!
    @IBOutlet var windSpeed: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var currentTemp: UILabel!
    @IBOutlet var bgImage: UIImageView!
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet var sunrise: UILabel!
    @IBOutlet var sunset: UILabel!
    @IBOutlet var backgroundScroll: UIScrollView!
    @IBOutlet var headerView: HeaderDetailView!
    @IBOutlet var refreshBtn: UIButton!

    
    @IBOutlet var animationView: UIView!
    @IBOutlet var summaryLabel: UILabel!
    
    @IBOutlet var firstDayLbl: UILabel!
    @IBOutlet var secondDayLbl: UILabel!
    @IBOutlet var thirdDayLbl: UILabel!
    @IBOutlet var fourthDayLbl: UILabel!
    @IBOutlet var fifthDayLbl: UILabel!
    
    @IBOutlet var firstDayImg: UIImageView!
    @IBOutlet var secondDayImg: UIImageView!
    @IBOutlet var thirdDayImg: UIImageView!
    @IBOutlet var fourthDayImg: UIImageView!
    @IBOutlet var fifthDayImg: UIImageView!
    
    @IBOutlet var firstDayLow: UILabel!
    @IBOutlet var secondDayLow: UILabel!
    @IBOutlet var thirdDayLow: UILabel!
    @IBOutlet var fourthDayLow: UILabel!
    @IBOutlet var fifthDayLow: UILabel!
    
    @IBOutlet var firstDayHigh: UILabel!
    @IBOutlet var secondDayHigh: UILabel!
    @IBOutlet var thirdDayHigh: UILabel!
    @IBOutlet var fourthDayHigh: UILabel!
    @IBOutlet var fifthDayHigh: UILabel!
    
    @IBOutlet var forecastStack: UIStackView!
    @IBOutlet var viewBreak1: UIView!
    @IBOutlet var viewBreak2: UIView!
    @IBOutlet var viewBreak3: UIView!
    @IBOutlet var hourlyLbl: UILabel!
    @IBOutlet var forecastLbl: UILabel!
    
    var weather = Weather(latitude: 35.996948, longitude: -78.899023)
    var timer: NSTimer!
    var isMainImgShowing = true
    var locationManager = CLLocationManager()
    var userLocation = Location()
    var useCurrentLocation = true
    var loading = false
    var gotLocation = false
    let WIDTH: CGFloat = 75
    let HEIGHT: CGFloat = 50
    let LBL_HEIGHT: CGFloat = 20
    var plusOrMinus: CGFloat = 1
    let notification = NSNotificationCenter.defaultCenter()
    var animationOn = false
    
    //-----------------------------------------------------------------------------------------
    
    
    //Loading views
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //notification.addObserver(self, selector: "waitForDownload", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        
        if userLocation.useSearchLocation == true {
            locationButton.alpha = 0.5
            useCurrentLocation = false
        }
        
        backgroundScroll.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        if checkAuthStatus() {
            locationManager.startUpdatingLocation()
        }
    }

    override func viewWillAppear(animated: Bool) {
        notification.addObserver(self, selector: "waitForDownload", name: UIApplicationDidBecomeActiveNotification, object: nil)
        notification.addObserver(self, selector: "startTime", name: UIApplicationDidBecomeActiveNotification, object: nil)
        animationOn = false
        startTime()
        //waitForDownload()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        notification.removeObserver(UIApplicationDidBecomeActiveNotification)
    }
    
    
    //-----------------------------------------------------------------------------------------
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let opacity = backgroundScroll.contentOffset.y / (358.0 * 75)
        
        if opacity >= 0 {
            
            switch round(backgroundScroll.contentOffset.y) {
            case 0...45:
                headerView.alpha = 1.0
            case 46...90:
                headerView.alpha = 0.9
            case 91...135:
                headerView.alpha = 0.8
            case 136...180:
                headerView.alpha = 0.7
            case 181...245:
                headerView.alpha = 0.6
            case 246...290:
                headerView.alpha = 0.5
            case 291...335:
                headerView.alpha = 0.4
            case 336...1000:
                headerView.alpha = 0.3
            default:
                headerView.alpha = 0.5
            }
        }
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if backgroundScroll.contentOffset.y < -100 {
            refreshBtn.alpha = 0.5
            waitForDownload()
        }
    }
    
    
    //-----------------------------------------------------------------------------------------
    
    
    //Updating weather information
    @IBAction func currentLocationPressed(sender: AnyObject) {
        
        if useCurrentLocation {
            locationButton.alpha = 0.5
            useCurrentLocation = false
        } else if checkAuthStatus() {
            gotLocation = true
            showLoadingHUD()
            useCurrentLocation = true
            userLocation.useSearchLocation = false
            waitForDownload()
            locationButton.alpha = 1.0
        } else {
            notification("Location Services Off", message: "Please change location preferences in the settings of your device.")
        }
    }
    
    @IBAction func refreshBtnPressed(sender: AnyObject) {
        refreshBtn.alpha = 0.5
        waitForDownload()
    }
    
    func updateUI() {
        
        weather.getImage(weather.todayIcon)
        bgImage.image = weather.bgImg
        currentTemp.text = "\(weather.currentTemp)º"
        todayLow.text = "\(weather.tempMinArr[0])º"
        todayHigh.text = "\(weather.tempMaxArr[0])º"
        humidity.text = "\(weather.humidity)%"
        windSpeed.text = "\(weather.windSpeed)MPH"
        mainImg.image = UIImage(named: "\(weather.getImageNumber(weather.todayIcon))")
        sunrise.text = weather.sunrise
        sunset.text = weather.sunset
        summaryLabel.text = weather.summary
        firstDayLbl.text = weather.firstDayLbl
        secondDayLbl.text = weather.secondDayLbl
        thirdDayLbl.text = weather.thirdDayLbl
        fourthDayLbl.text = weather.fourthDayLbl
        fifthDayLbl.text = weather.fifthDayLbl
        firstDayImg.image = UIImage(named: "\(weather.getImageNumber(weather.forecastIconArray[0]))")
        secondDayImg.image = UIImage(named: "\(weather.getImageNumber(weather.forecastIconArray[1]))")
        thirdDayImg.image = UIImage(named: "\(weather.getImageNumber(weather.forecastIconArray[2]))")
        fourthDayImg.image = UIImage(named: "\(weather.getImageNumber(weather.forecastIconArray[3]))")
        fifthDayImg.image = UIImage(named: "\(weather.getImageNumber(weather.forecastIconArray[4]))")
        firstDayLow.text = weather.tempMinArr[1] + "º"
        firstDayHigh.text = weather.tempMaxArr[1] + "º"
        secondDayLow.text = weather.tempMinArr[2] + "º"
        secondDayHigh.text = weather.tempMaxArr[2] + "º"
        thirdDayLow.text = weather.tempMinArr[3] + "º"
        thirdDayHigh.text = weather.tempMaxArr[3] + "º"
        fourthDayLow.text = weather.tempMinArr[4] + "º"
        fourthDayHigh.text = weather.tempMaxArr[4] + "º"
        fifthDayLow.text = weather.tempMinArr[5] + "º"
        fifthDayHigh.text = weather.tempMaxArr[5] + "º"
        checkAnimation()
    }
    
    func waitForDownload() {
        if weather.connectedToNetwork() {
            showLoadingHUD()
            if !userLocation.useSearchLocation {
                changeURL(BASE_URL, latitude: weather.latitude, longitude: weather.longitude)
            } else {
                changeURL(BASE_URL, latitude: userLocation.latitude, longitude: userLocation.longitude)
            }
            if !self.userLocation.useSearchLocation {
                self.weather.reverseGeocoding(self.weather.latitude, longitude: self.weather.longitude, label: self.location)
            } else {
                self.location.text = self.userLocation.locationName
            }
            weather.downloadWeatherDetails { () -> () in
                self.updateUI()
                self.updateScrollView()
                self.hideLoadingHUD()
                self.showHide(false)
                if self.refreshBtn.alpha == 0.5 {
                    self.refreshBtn.alpha = 1.0
                }
            }
            getDate()
        } else {
            notification("Internet Connection Lost!", message: "You are currently not connected to the internet.")
        }
        
    }
    
    func changeURL(base: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        weather.weatherURL = "\(base)\(latitude),\(longitude)"
        
    }
    
    
    //-----------------------------------------------------------------------------------------
    
    
    //Location methods to get user coordinates
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

            if userLocation.useSearchLocation == false && useCurrentLocation == true {
            
            switch status {
            case .NotDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .AuthorizedWhenInUse:
                locationManager.startUpdatingLocation()
            case .Denied:
                notification("Location Services Off", message: "Please search for a location by using the search icon in the top right corner.")
                locationButton.alpha = 0.5
                useCurrentLocation = false
            default:
                break
            }
            
        } else {
            waitForDownload()
        }

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locations = locations.last! as CLLocation
        weather.latitude = locations.coordinate.latitude
        weather.longitude = locations.coordinate.longitude
        if gotLocation == false && !userLocation.useSearchLocation {
            waitForDownload()
            gotLocation = true
        }
    }
    
    func checkAuthStatus() -> Bool {
        
        if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse {
            return false
        }
        return true
    }

    
    //-----------------------------------------------------------------------------------------
    
    
    //Flips the main image view with the details view
    @IBAction func mainImgTap(gesture: UIGestureRecognizer) {
        
        if (isMainImgShowing) {
            UIView.transitionFromView(mainImgView, toView: detailsView, duration: 1.0, options: [UIViewAnimationOptions.TransitionFlipFromRight, UIViewAnimationOptions.ShowHideTransitionViews], completion: nil)
        } else {
            UIView.transitionFromView(detailsView, toView: mainImgView, duration: 1.0, options: [UIViewAnimationOptions.TransitionFlipFromLeft, UIViewAnimationOptions.ShowHideTransitionViews], completion: nil)
        }
        
        isMainImgShowing = !isMainImgShowing
        
    }
    
    
    //-----------------------------------------------------------------------------------------
    
    
    //Manages the date
    func startTime() {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "getDate", userInfo: nil, repeats: true)
        animationOn = false
    }
    
    func getDate() {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .FullStyle
        formatter.stringFromDate(date)
        let dayArr = String(formatter.stringFromDate(date)).componentsSeparatedByString(",")
        let daynumberArr = dayArr[1].componentsSeparatedByString(" ")
        let dayNumber = Int(daynumberArr[2])!
        var ending = ""
    
        switch dayNumber {
        case 1, 21, 31:
            ending = "st"
        case 2, 22:
            ending = "nd"
        case 3, 23:
            ending = "rd"
        case 4...20, 24...30:
            ending = "th"
        default:
            ending = ""
        }
        
        timeDay.text = "\(dayArr[0]), \(dayArr[1])\(ending)"
    }
    
    
    //-----------------------------------------------------------------------------------------
    
    
    //Manages when the images should be hidden and shown
    func showHide(showHide: Bool) {
        
        self.summaryLabel.hidden = showHide
        self.location.hidden = showHide
        self.mainImg.hidden = showHide
        self.currentTemp.hidden = showHide
        self.timeDay.hidden = showHide
        self.firstDayLbl.hidden = showHide
        self.secondDayLbl.hidden = showHide
        self.thirdDayLbl.hidden = showHide
        self.fourthDayLbl.hidden = showHide
        self.fifthDayLbl.hidden = showHide
        self.forecastStack.hidden = showHide
        self.viewBreak1.hidden = showHide
        self.viewBreak2.hidden = showHide
        self.viewBreak3.hidden = showHide
        self.hourlyLbl.hidden = showHide
        self.forecastLbl.hidden = showHide
    }
    
    
    //-----------------------------------------------------------------------------------------
    
    
    //Handles the horizontal hourly scrollView
    func updateScrollView() {
        
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
        
        for var x = 1; x <= 24; x++ {
            
            let img = UIImage(named: "\(weather.getImageNumber(weather.iconArray[x-1]))")
            let imgView = UIImageView(image: img)
            
            let hourLbl = UILabel()
            hourLbl.text = self.weather.hourlyArray[x - 1]
            hourLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
            
            let tempLbl = UILabel()
            tempLbl.text = "\(self.weather.temperatureArray[x - 1])º"
            tempLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
            
            scrollView.addSubview(hourLbl)
            scrollView.addSubview(imgView)
            scrollView.addSubview(tempLbl)
            
            hourLbl.frame = CGRectMake(-WIDTH + (WIDTH * CGFloat(x)), 0, WIDTH, LBL_HEIGHT)
            imgView.frame = CGRectMake(-WIDTH + (WIDTH * CGFloat(x)), LBL_HEIGHT, WIDTH, HEIGHT)
            tempLbl.frame = CGRectMake(-WIDTH + (WIDTH * CGFloat(x)), LBL_HEIGHT + HEIGHT, WIDTH, LBL_HEIGHT)
            
            imgView.contentMode = .ScaleAspectFit
            hourLbl.textAlignment = .Center
            hourLbl.textColor = UIColor.blackColor()
            tempLbl.textAlignment = .Center
            tempLbl.textColor = UIColor.blackColor()
            
        }
        
        self.scrollView.contentSize = CGSizeMake(WIDTH * 24, (HEIGHT + 2 * LBL_HEIGHT))
        
    }
    
    
    //-----------------------------------------------------------------------------------------
    
    
    //Alert user of problem
    func notification(title: String, message: String) {
        
        let titlePrompt = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        titlePrompt.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            
        }))
        
        self.presentViewController(titlePrompt, animated: true, completion: nil)
        
    }
    
    
    //-----------------------------------------------------------------------------------------
    
    
    //Go to Search ViewController to add locations
    @IBAction func searchBtnPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("searchSegue", sender: nil)
    }
    
    
    //-----------------------------------------------------------------------------------------
    
    
    //Progress loading bar methods
    private func showLoadingHUD() {
        let hud = MBProgressHUD.showHUDAddedTo(contentView, animated: true)
        hud.labelText = "Loading..."
        loading = true
    }
    
    private func hideLoadingHUD() {
        MBProgressHUD.hideAllHUDsForView(contentView, animated: true)
        loading = false
    }
    
    
    //-----------------------------------------------------------------------------------------
    
    
    func addSnowflakes(image1: String, image2: String) {
        
        let height = animationView.frame.height
        
        for _ in 0...25 {
            
            let square = UIImageView()
            let snowflake = UIImageView()
            
            let randomOffset = CGFloat(arc4random_uniform(350))
            let controlPointx = CGFloat(arc4random_uniform(414))
            
            if plusOrMinus == 1 {
                plusOrMinus = -1
            } else {
                plusOrMinus = 1
            }
            
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: 0 + randomOffset, y: 0))
            path.addCurveToPoint(CGPoint(x: 0 + randomOffset, y: height), controlPoint1: CGPoint(x: (plusOrMinus * controlPointx), y: height / 2), controlPoint2: CGPoint(x: (controlPointx + randomOffset), y: height / 2))
            
            let anim = CAKeyframeAnimation(keyPath: "position")
            
            anim.path = path.CGPath
            
            anim.rotationMode = kCAAnimationRotateAuto
            anim.repeatCount = Float.infinity
            anim.duration = Double(arc4random_uniform(40) + 30) / 10
            anim.timeOffset = Double(arc4random_uniform(290))
            
            let randomImage = arc4random_uniform(2)
            
            if randomImage == 0 {
                square.image = UIImage(named: image1)
                square.alpha = 0.6
                square.frame = CGRect(x: -50, y: 300, width: 20, height: 20)
                animationView.addSubview(square)
                square.layer.addAnimation(anim, forKey: "animate position along path")
            } else {
                snowflake.image = UIImage(named: image2)
                snowflake.alpha = 0.6
                snowflake.frame = CGRect(x: -50, y: 300, width: 20, height: 20)
                animationView.addSubview(snowflake)
                snowflake.layer.addAnimation(anim, forKey: "animate position along path")
            }
        }
    }
    
    func addRain(image: String) {
        
        let height = animationView.frame.height
        
        for _ in 0...20 {
            
            let randomPoint = CGFloat(arc4random_uniform(415))
            
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: randomPoint, y: 0))
            path.addLineToPoint(CGPoint(x: randomPoint, y: height))
            
            let anim = CAKeyframeAnimation(keyPath: "position")
            
            anim.path = path.CGPath
            
            anim.duration = Double(arc4random_uniform(5) + 25 / 10)
            anim.timeOffset = Double(arc4random_uniform(200))
            anim.repeatCount = Float.infinity
            
            let rainDrop = UIImageView()
            rainDrop.image = UIImage(named: image)
            rainDrop.alpha = 0.5
            rainDrop.frame = CGRect(x: -50, y: 300, width: 10, height: 20)
            animationView.addSubview(rainDrop)
            rainDrop.layer.addAnimation(anim, forKey: "animate position along path")
            
        }
    }
    
    func checkAnimation() {
        if weather.getImageNumber(weather.todayIcon) == 9 {
            if !animationOn {
                addSnowflakes("mySnowflake.png", image2: "snowflakeWhite2.png")
                animationOn = true
            }
        } else if weather.getImageNumber(weather.todayIcon) == 3 {
            if !animationOn {
                addRain("raindrop.png")
                animationOn = true
            }
        } else {
            for view in animationView.subviews {
                view.removeFromSuperview()
            }
            animationOn = false
        }
    }
}
