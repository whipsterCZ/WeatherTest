//
//  Locations.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 15/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class Locations: NSObject, CLLocationManagerDelegate {
    
    var apiUrl : String
    var apiKey : String
    
    var selectedLocation : Location? //Location.defaultLocation
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

    var locationFoundHandler : ((locations: [LocationData])->Void)?
    var connectionManager = AFHTTPRequestOperationManager()
    var TableViewForReload: UITableView?
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    
    init(apiUrl:String, apiKey:String) {
        self.apiUrl = apiUrl
        self.apiKey = apiKey
        
        super.init()
        loadState()
    }
   
    
    func loadState() {
        currentLocationAdded = userDefaults.boolForKey("currentLocationAdded")
        fetchLocationList()
        fetchSelectedLocation()
               
    }
    
    
    func saveState() {
        userDefaults.setBool(currentLocationAdded, forKey: "currentLocationAdded")
        userDefaults.synchronize()
        DI.context.saveManagedContext()
        
    }
    
    func fetchLocationList() -> [Location] {
        
        let fetchRequest = NSFetchRequest(entityName: Location.entity)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "city", ascending: true),
            NSSortDescriptor(key: "country", ascending: true)
        ]
        
        if let locations = DI.context.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Location] {
            locationList = locations
        }
        TableViewForReload?.reloadData()
        return locationList
    }
    
    func fetchSelectedLocation() {
        let fetchRequest = DI.context.managedObjectModel.fetchRequestFromTemplateWithName("selectedLocation", substitutionVariables: ["test":"test"])
        
        if let locations = DI.context.managedObjectContext!.executeFetchRequest(fetchRequest!, error: nil) as? [Location] {
            if let location = locations.first {
                selectedLocation = location
            }
        }
        
    }
    
    func addLocationToList(location:LocationData) -> Location?
    {
        if locationList.filter({ $0.latLng == location.latLng }).count == 0 {
            
            let managed = Location.addManagedObjectFromLocation(location)
            fetchLocationList()
            saveState()
            return managed
        }
        return nil
    }

    func addCurrentLocationToList()
    {
        if ( !currentLocationAdded) {
            locationFoundHandler = { (locations:[LocationData]) -> Void in
                if let location = locations.first {
                    
                    if let managed = self.addLocationToList(location) {
                        managed.geoCurrent = true
                        managed.isSelected = true
                        self.selectedLocation = managed
                        self.updateSelectedLocationInList()
                    }
                    
                    self.currentLocationAdded = true
                } else {
                    NSLog("My WeatherLocation is unknown, despite my coreLocation exists")
                }
            }
            self.findCurrentCoreLocation()
        }
    }
    
    func updateSelectedLocationInList()
    {
        for  location in locationList {
            location.isSelected = location == selectedLocation
        }
    }
    
    
    
    //MARK: - Wheater Location API
    func searchLocations(query:String, limit:Int, success:([LocationData])->Void) {
        
        if query == "" {
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
                
                if let search = root.objectForKey("search_api") as? NSDictionary {
                    var foundLocations = [LocationData]()
                    var result = search.objectForKey("result") as NSArray
                    for resultLocation in result {
                        if let loc = resultLocation as? NSDictionary  {
                            var city = ((loc.objectForKey("areaName") as NSArray).objectAtIndex(0) as NSDictionary).objectForKey("value") as String
                            var country = ((loc.objectForKey("country") as NSArray).objectAtIndex(0) as NSDictionary).objectForKey("value") as String
                            var latLng = self.formatLatLng(loc.objectForKey("latitude") as String, lng:loc.objectForKey("longitude") as String)
//                            var weatherUrl = ((loc.objectForKey("weatherUrl") as NSArray).objectAtIndex(0) as NSDictionary).objectForKey("value") as String
                           
                            let location = LocationData(latLng:latLng, city:city, country:country)
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