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
            //Add to locationList / if not contained
            if self.addLocationToList(location) != nil  {
                _selectedLocation = location
            } else {
                // only identitical instance
                _selectedLocation = self.getLocationInstanceFormList(location)
            }
            notifyChange()
        }
        get {
            return _selectedLocation!
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
    var scheduler: NSTimer?
    
    init(apiUrl:String, apiKey:String) {
        self.apiUrl = apiUrl
        self.apiKey = apiKey
        
        super.init()
        NSLog("init location")
        
        loadState()
    }
   
    
    func loadState() {
        currentLocationAdded = userDefaults.boolForKey("currentLocationAdded")
        
        if let locationListData = userDefaults.dataForKey("locationListData") {
            locationList = NSKeyedUnarchiver.unarchiveObjectWithData(locationListData) as [Location]
        }
        
        if let latLng = userDefaults.objectForKey("selectedLatLng") as? String {
            if let listedLocation = getLocationFromList(latLng) {
                _selectedLocation = listedLocation
            } else {
                _selectedLocation = defaultLocation
            }
        } else {
            _selectedLocation = defaultLocation //it loads default location and add it to locationList
        }
        
    }
    
    func getLocationInstanceFormList(location:Location) -> Location?
    {
        return getLocationFromList(location.latLng)
    }
    func getLocationFromList(latLng:String) -> Location?
    {
        for location in locationList {
            if ( location.latLng == latLng) {
                return location
            }
        }
        return nil
    }
    
    
    func saveState() {
        userDefaults.setBool(currentLocationAdded, forKey: "currentLocationAdded")
        
        var locationListData = NSKeyedArchiver.archivedDataWithRootObject(locationList)
        userDefaults.setObject(locationListData, forKey: "locationListData")
        
        userDefaults.setObject(selectedLocation.latLng, forKey: "selectedLatLng")
        
        userDefaults.synchronize()
        
    }
    
    func notifyChange()
    {
        NSNotificationCenter.defaultCenter().postNotificationName(RELOAD_NOTIFICATION, object: nil)
    }
    
    func startUpdatingWeather()
    {
        var weather: Weather?
        for location in DI.context.locations.locationList {
            var weather = location.weather //if weather doesnt exists it fetches data automaticaly
        }
        weather = selectedLocation.weather //if weather doesnt exists it fetches data automaticaly
        
        let updateInterval = (DI.context.getParameter("weather_update_interval", defaultValue: "1800")! as NSString).doubleValue
        scheduler = NSTimer.scheduledTimerWithTimeInterval(updateInterval, target: self, selector: "updateWeather", userInfo: nil, repeats: true)
    }
    
    func stopUpdatingWeather() {
        scheduler?.invalidate()
    }
    func updateWeather(){
        for location in DI.context.locations.locationList {
            location.weather.fetchWeather()
        }
    }
    
      
    func addLocationToList(location:Location) -> Location?
    {
        if !contains(locationList, location) {
            locationList.append(location)
            notifyChange()
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
//                    self.addLocationToList(location)
                    self.selectedLocation = location
                    self.currentLocationAdded = true                    
                } else {
                    NSLog("My WeatherLocation is unknown, despite my coreLocation exists")
                }
            }
            self.findCurrentCoreLocation()
        }
    }
    
    func selectNextLocation() -> Bool {
        if ( locationList.count > 1 ) {
            if let index = find(locationList, selectedLocation) {
                var newIndex = (index+1 ) % locationList.count
                selectedLocation = locationList[newIndex]
                notifyChange()
                return true
            }
        }
        return false
    }
    
    func selectPrevLocation() -> Bool {
        if ( locationList.count > 1 ) {
            if let index = find(locationList, selectedLocation) {
                var newIndex = index==0 ? (locationList.count-1) : (index-1)
               selectedLocation = locationList[newIndex]
               notifyChange()
               return true
            }
        }
        return false
        
    }
    
    lazy var defaultLocation: Location = {
        let location = Location(latLng: "50.083,14.467", city: "Prague", region:"Czech Republic", country: "Czech Republic")
            //location.isSelected = true
            return location
    }()
    
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
                            var region = ((loc["region"] as [NSDictionary])[0] as NSDictionary)["value"] as String
                            if country == "United States of America" { country = "USA" }
                            var latLng = self.formatLatLng(loc["latitude"] as String, lng:loc["longitude"] as String)
//                            var weatherUrl = ((loc.["weatherUrl"] as NSArray)[0] as NSDictionary)["value"] as String
                           
                            let location = Location(latLng:latLng, city:city, region:region, country:country)
                            foundLocations.append(location)
                        }
                    }
                    success(foundLocations)
                }
            }
        
        
        }) { (request, error) -> Void in
            NSLog("AFNetworking Error: Search API did not responded ")
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