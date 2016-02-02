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

class MainVC: UIViewController, CLLocationManagerDelegate {

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
    @IBOutlet var locationStack: UIStackView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var currentTemp: UILabel!
    @IBOutlet var bgImage: UIImageView!
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet var sunrise: UILabel!
    @IBOutlet var sunset: UILabel!
    
    var weather = Weather(latitude: 35.996948, longitude: -78.899023)
    var timer: NSTimer!
    var isMainImgShowing = true
    var locationManager = CLLocationManager()
    var userLocation = Location()
    var useCurrentLocation = true
    var loading = false
    
    
    
    //Loading views
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if userLocation.useSearchLocation == true {
            locationButton.alpha = 0.5
            useCurrentLocation = false
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if userLocation.useSearchLocation == false {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidAppear(animated: Bool) {

        startTime()
    }
    
    @IBAction func currentLocationPressed(sender: AnyObject) {
        
        if useCurrentLocation {
            locationButton.alpha = 0.5
            useCurrentLocation = false
        } else {
            showLoadingHUD()
            locationManager.startUpdatingLocation()
            locationButton.alpha = 1.0
            useCurrentLocation = true
        }
        
    }
    
    
    
    //Updating weather information
    @IBAction func refreshBtnPressed(sender: AnyObject) {
        
        if useCurrentLocation {
            showLoadingHUD()
            locationManager.startUpdatingLocation()
        } else {
            waitForDownload()
        }
    }
    
    func updateUI() {
        
        weather.getImage(weather.todayIcon)
        bgImage.image = weather.bgImg
        currentTemp.text = "\(weather.currentTemp)º"
        todayLow.text = "\(weather.tempMin)º"
        todayHigh.text = "\(weather.tempMax)º"
        humidity.text = "\(weather.humidity)%"
        windSpeed.text = "\(weather.windSpeed)MPH"
        mainImg.image = UIImage(named: "\(weather.getImageNumber(weather.todayIcon))")
        sunrise.text = weather.sunrise
        sunset.text = weather.sunset
        
    }
    
    func waitForDownload() {
        showLoadingHUD()
        weather.downloadWeatherDetails { () -> () in
            self.updateUI()
            self.updateScrollView()
            self.hideLoadingHUD()
            self.showHide(false)
        }
        getDate()
    }
    
    func changeURL(base: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        weather.weatherURL = "\(base)\(latitude),\(longitude)"
        
    }
    
    
    
    //Location methods to get user coordinates
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if userLocation.useSearchLocation == false && useCurrentLocation == true {
            if status == .AuthorizedWhenInUse {
                locationManager.startUpdatingLocation()
                weather.latitude = locationManager.location!.coordinate.latitude
                weather.longitude = locationManager.location!.coordinate.longitude
                weather.reverseGeocoding(weather.latitude, longitude: weather.longitude, label: location)
                changeURL(BASE_URL, latitude: weather.latitude, longitude: weather.longitude)
                locationManager.stopUpdatingLocation()
                waitForDownload()
            } else {
                print("Please search a location that you are interested in.")
            }
        } else {
            userLocation.useSearchLocation = false
            location.text! = userLocation.locationName
            weather.latitude = userLocation.latitude
            weather.longitude = userLocation.longitude
            changeURL(BASE_URL, latitude: weather.latitude, longitude: weather.longitude)
            waitForDownload()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locations = locations.last! as CLLocation
        weather.latitude = locations.coordinate.latitude
        weather.longitude = locations.coordinate.longitude
        weather.reverseGeocoding(weather.latitude, longitude: weather.longitude, label: location)
        changeURL(BASE_URL, latitude: weather.latitude, longitude: weather.longitude)
        waitForDownload()
        locationManager.stopUpdatingLocation()
    }
    

    
    //Flips the main image view with the details view
    @IBAction func mainImgTap(gesture: UIGestureRecognizer) {
        
        if (isMainImgShowing) {
            UIView.transitionFromView(mainImgView, toView: detailsView, duration: 1.0, options: [UIViewAnimationOptions.TransitionFlipFromRight, UIViewAnimationOptions.ShowHideTransitionViews], completion: nil)
        } else {
            UIView.transitionFromView(detailsView, toView: mainImgView, duration: 1.0, options: [UIViewAnimationOptions.TransitionFlipFromLeft, UIViewAnimationOptions.ShowHideTransitionViews], completion: nil)
        }
        
        isMainImgShowing = !isMainImgShowing
        
    }
    
    
    
    //Manages the date
    func startTime() {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "getDate", userInfo: nil, repeats: true)
        
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
        case 1:
            ending = "st"
        case 2:
            ending = "nd"
        case 3:
            ending = "rd"
        case 4...20:
            ending = "th"
        case 21:
            ending = "st"
        case 22:
            ending = "nd"
        case 23:
            ending = "rd"
        case 24...30:
            ending = "th"
        case 31:
            ending = "st"
        default:
            ending = ""
        }
        
        timeDay.text = "\(dayArr[0]), \(dayArr[1])\(ending)"
    }
    
    
    
    //Manages when the images should be hidden and shown
    func showHide(showHide: Bool) {
        
        self.locationStack.hidden = showHide
        self.mainImg.hidden = showHide
        self.currentTemp.hidden = showHide
        self.timeDay.hidden = showHide
        
    }
    
    
    
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
    
    
    
    //Go to Search ViewController to add locations
    @IBAction func searchBtnPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("searchSegue", sender: nil)
    }
    
    
    
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
    
}
