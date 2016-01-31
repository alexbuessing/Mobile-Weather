//
//  SearchVC.swift
//  MobileWeather
//
//  Created by Alexander Buessing on 1/27/16.
//  Copyright © 2016 Buessing. All rights reserved.
//

import UIKit
import CoreLocation

class SearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var addLocationText: UITextField!
    
    var locationArray = [String]()
    var coordinateArray = [[Double]]()
    var isLocation: Bool = true
    
    var weather: Weather!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addLocationText.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.reloadData()
        addTapGesture()
        loadData()
        
    }
    
    
    
    //Loads locations and coordinates that user requested
    func loadData() {
        
        if let myArr = defaults.objectForKey("locationArray") as? [String] {
            locationArray = myArr
            //print(myArr)
        }
        
        if let myCoords = defaults.objectForKey("coordinateArray") as? [[Double]] {
            coordinateArray = myCoords
            //print(myCoords)
        }
    }
    
    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            else if placemarks?.count > 0 {
                let pm = placemarks![0]
                self.locationArray.append("\(pm.subAdministrativeArea!), \(pm.administrativeArea!)")
                self.defaults.setObject(self.locationArray, forKey: "locationArray")
                self.tableView.reloadData()
            }
        })
        
    }
    
    //Get Coordinates of users input
    func forwardGeocoding(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                //print(error)
                self.notification("Location Not Found", message: "Please enter a new location")
                self.addLocationText.text = ""
                return
            }
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                self.coordinateArray.append([coordinate!.latitude, coordinate!.longitude])
                self.defaults.setObject(self.coordinateArray, forKey: "coordinateArray")
                self.reverseGeocoding(coordinate!.latitude, longitude: coordinate!.longitude)
                self.addLocationText.text = ""
                
            }
        })
    }
    
    
    
    //Adds location to UITableView
    @IBAction func addLocationBtnPressed(sender: AnyObject) {

        if addLocationText.text != nil && addLocationText.text != "" {
            forwardGeocoding(addLocationText.text!)
            
        } else {
            notification("Oops! No Location Found", message: "Please enter a location.")
        }
        
    }
    
    
    
    //Alert user of failed location input
    func notification(title: String, message: String) {
    
        let titlePrompt = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    
            titlePrompt.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
    
            }))
        
        self.presentViewController(titlePrompt, animated: true, completion: nil)
                    
    }
    
    
    
    //Functions to handle UITableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? LocationCell {
            
            let locations = locationArray[indexPath.row]
            cell.configureCell(locations)
            return cell
            
        } else {
            return LocationCell()
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        coordinateArray.removeAtIndex(indexPath.row)
        defaults.setObject(coordinateArray, forKey: "coordinateArray")

        locationArray.removeAtIndex(indexPath.row)
        defaults.setObject(locationArray, forKey: "locationArray")
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let location = Location()
        location.locationName = locationArray[indexPath.row]
        location.latitude = coordinateArray[indexPath.row][0]
        location.longitude = coordinateArray[indexPath.row][1]
        location.useSearchLocation = true
        
        performSegueWithIdentifier("weatherSegue", sender: location)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "weatherSegue" {
            
            if let weatherVC = segue.destinationViewController as? ViewController {
                if let place = sender as? Location {
                    weatherVC.userLocation = place
                }
            }
        }
    }
    
    
    //Return to Home Screen
    @IBAction func backBtnPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    //Functions that hide keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        addLocationText.resignFirstResponder()
        
        return true
    }
    
    func addTapGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
        
    }
    
    func hideKeyboard() {
        addLocationText.resignFirstResponder()
    }
    
}
