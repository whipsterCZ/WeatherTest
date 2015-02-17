//
//  Location.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 16/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import Foundation
import CoreData

struct LocationData {
    var latLng:String
    var city:String
    var country:String
    func getTitle() ->String {
        return "\(city), \(country)"
    }
}

class Location: NSManagedObject {

    class var entity: String { return "Location" }

    @NSManaged var latLng: String
    @NSManaged var city: String
    @NSManaged var country: String
    @NSManaged var geoCurrent: Bool
    @NSManaged var isSelected: Bool
    
    
    func getTitle() ->String {
        return "\(city), \(country)"
    }
    
    class func addManagedObjectFromLocation(location :LocationData) -> Location
    {
        let managed = NSEntityDescription.insertNewObjectForEntityForName(self.entity, inManagedObjectContext: DI.context.managedObjectContext!) as Location
        managed.latLng = location.latLng
        managed.city = location.city
        managed.country = location.country
//        managed.geoCurrent = location.geoCurrent
//        managed.isSelected = location.isSelected

        return managed
    }
    
    class func StandaloneEntity() -> Location
    {
        return Location()
    }
    
    class var defaultLocation: Location {
        let location = Location()
        location.city = "Default City"
        location.country = "Czech Republic"
        location.geoCurrent = false
        location.isSelected = true
        location.latLng = DI.context.locations.formatLatLng(50.083, lng: 14.467)
        return location
    }

}

func == (lhs: Location, rhs: Location) -> Bool {
    return lhs.latLng == rhs.latLng
}