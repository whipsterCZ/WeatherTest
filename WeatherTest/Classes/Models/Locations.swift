//
//  Locations.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 15/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import UIKit
import CoreLocation

class Locations: NSObject, CLLocationManagerDelegate {
    
    var apiUrl : String
    var apiKey : String
    
    //Location.defaultLocation
    private var _selectedLocation: Location?
    var selectedLocation : Location {
        set(location) {
            _selectedLocation = location
            saveState()
        }
        get {
            if let location = _selectedLocation {
                return location
            }
            return Location.defaultLocation
        }
    }
    var locationList = [Location]()
    var currentLocationAdded = false
    
    var locationManager = CLLocationManager()
    var lastKnownLocation: CLLocation?
    // Handler which is called after retrieving current location
    var coreLocationFoundHandler : ((location:CLLocation)->Void)?
    
//    var geocoder = CLGeocoder()
//    var placemark: CLPlacemark?
//    // handler which is called after retrieving current place (address)
//    var placemarkFoundHandler : ((place:String)->Void)?

    var locationFoundHandler : ((locations: [Location])->Void)?
    var connectionManager = AFHTTPRequestOperationManager()
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    init(apiUrl:String, apiKey:String) {
        self.apiUrl = apiUrl
        self.apiKey = apiKey
        
        super.init()
        loadState()
    }
   
    
    func loadState() {
        currentLocationAdded = userDefaults.boolForKey("currentLocationAdded")
        
        if let locationListData = userDefaults.dataForKey("locationListData") {
            locationList = NSKeyedUnarchiver.unarchiveObjectWithData(locationListData) as [Location]
        }
        
        if let selectedLocationData = userDefaults.dataForKey("selectedLocationData") {
            _selectedLocation = NSKeyedUnarchiver.unarchiveObjectWithData(selectedLocationData) as? Location
        }
        
    }
    
    
    func saveState() {
        userDefaults.setBool(currentLocationAdded, forKey: "currentLocationAdded")
        
        var locationListData = NSKeyedArchiver.archivedDataWithRootObject(locationList)
        userDefaults.setObject(locationListData, forKey: "locationListData")
        
        var selectedLocationData = NSKeyedArchiver.archivedDataWithRootObject(selectedLocation)
        userDefaults.setObject(selectedLocationData, forKey: "selectedLocationData")
        
        userDefaults.synchronize()
        NSNotificationCenter.defaultCenter().postNotificationName(RELOAD_NOTIFICATION, object: nil)
        
    }
    
      
    func addLocationToList(location:Location) -> Location?
    {
//        if locationList.filter({ $0.latLng == location.latLng }).count == 0 {
        if !contains(locationList, location) {
            locationList.append(location)
            saveState()
            return location
        }
        return nil
    }

    func addCurrentLocationToList()
    {
        if ( !currentLocationAdded) {
            locationFoundHandler = { (locations:[Location]) -> Void in
                if let location = locations.first {
                    location.isCurrent = true
                    self.addLocationToList(location)
                    self.selectedLocation = location
                    self.currentLocationAdded = true
                } else {
                    NSLog("My WeatherLocation is unknown, despite my coreLocation exists")
                }
            }
            self.findCurrentCoreLocation()
        }
    }     
    
    //MARK: - Weather Location API
    func searchLocations(query:String, limit:Int, success:([Location])->Void) {
        
        if countElements(query)<4 { // <3  Looks much better :)
            return
        }
        
        var params = [
            "key": apiKey,
            "query" : query,
            "popular" : true,
            "format" : "json",
            "limit" : limit
        ]
        
        connectionManager.GET(apiUrl, parameters: params, success: { (request, response) -> Void in
            
            
            if let root = response as? NSDictionary {
                if let data = root.objectForKey("data") as? NSDictionary
                {
                    if let error = root.objectForKey("error") as? NSArray {
                        //no match
                        return
                    }
                }
                
                if let search = root["search_api"] as? NSDictionary {
                    var foundLocations = [Location]()
                    var result = search["result"] as NSArray
                    for resultLocation in result {
                        if let loc = resultLocation as? NSDictionary  {
                            var city = ((loc["areaName"] as [NSDictionary])[0] as NSDictionary)["value"] as String
                            var country = ((loc["country"] as [NSDictionary])[0] as NSDictionary)["value"] as String
                            if country == "United States of America" { country = "USA" }
                            var latLng = self.formatLatLng(loc["latitude"] as String, lng:loc["longitude"] as String)
//                            var weatherUrl = ((loc.["weatherUrl"] as NSArray)[0] as NSDictionary)["value"] as String
                           
                            let location = Location(latLng:latLng, city:city, country:country)
                            foundLocations.append(location)
                        }
                    }
                    success(foundLocations)
                }
            }
        
        
        }) { (request, error) -> Void in
            NSLog("Error: \(error)")
        }
        
    }
    
    
    
    //MARK: - CoreLocation
    
    //Find current location via CoreLocation service
    func findCurrentCoreLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    //Translate CLLocation to Addres (after succeess handler is called)
    // Use search api
//    func findPlacemark(location: CLLocation) {
//        geocoder.reverseGeocodeLocation(location, completionHandler: { (places, error) -> Void in
//            if error == nil && places.count>0 {
//                self.placemark = places.first as? CLPlacemark
//                var place = "\(self.placemark!.locality), \(self.placemark!.country)"
//                self.placeFoundHandler?(place: place)
//                
//            } else {
//                NSLog(error.debugDescription)
//            }
//        })
//    }
    
    //MARK: - CLLocationManagerDelegate
   
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if ( status == CLAuthorizationStatus.AuthorizedWhenInUse || status == CLAuthorizationStatus.Authorized ) {
            locationManager.startUpdatingLocation()
        }
    }
    
    //My CoreLocation has been discovered
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {

        lastKnownLocation = newLocation
        locationManager.stopUpdatingLocation()
        coreLocationFoundHandler?(location: newLocation) //this is fancy - custom user callback
        var latLng = formatLatLng(newLocation.coordinate.latitude, lng :newLocation.coordinate.longitude)
        
//        findPlacemark(newLocation);
        searchLocations(latLng, limit: 1, success: locationFoundHandler!)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        UIAlertView(title: "Failed to get core location", message: error.debugDescription, delegate: nil, cancelButtonTitle: "OK").show()
    }

    
    
    //MARK: - Convenience
    
    func formatLatLng(lat:AnyObject, lng:AnyObject) -> String
    {
        return "\(lat),\(lng)"
    }

}