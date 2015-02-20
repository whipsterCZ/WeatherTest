//
//  Location.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 16/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import Foundation


class Location: NSObject {


    var latLng: String
    var city: String
    var country: String
    var isCurrent = false
//    var isSelected = false
    
    init(latLng:String, city:String, country:String) {
        self.latLng = latLng
        self.city = city
        self.country = country
    }
    
    lazy var weather: Weather = {        
        return Weather(latLng: self.latLng)
    }()
    
    func getTitle() ->String {
        return "\(city), \(country)"
    }
    
    
    class var defaultLocation: Location  {
        get {
            var latLng = DI.context.locations.formatLatLng(50.083, lng: 14.467)
            let location = Location(latLng: latLng, city: "Prague", country: "Czech Republic")
//            location.isSelected = true
            return location
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(latLng, forKey: "latLng")
        aCoder.encodeObject(city , forKey: "city")
        aCoder.encodeObject(country, forKey: "country")
        aCoder.encodeBool(isCurrent, forKey: "isCurrent")
//        aCoder.encodeBool(isSelected, forKey: "isSelected")
    }
    
    init(coder aDecoder: NSCoder!) {
        latLng =    aDecoder.decodeObjectForKey("latLng") as String
        city =      aDecoder.decodeObjectForKey("city") as String
        country =   aDecoder.decodeObjectForKey("country") as String
//        isSelected = aDecoder.decodeBoolForKey("isSelected")
        isCurrent = aDecoder.decodeBoolForKey("isCurrent")
    }
    

}

func == (lhs: Location, rhs: Location) -> Bool {
    return lhs.latLng == rhs.latLng
}