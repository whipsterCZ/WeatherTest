//
//  Location.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 16/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import Foundation


class Location: NSObject, Equatable {


    var latLng: String
    var city: String
    var region:String
    var country: String
    var isCurrent = false
//    var isSelected = false
    
    init(latLng:String, city:String, region:String, country:String) {
        self.latLng = latLng
        self.city = city
        self.country = country
        self.region = region
    }
    
    lazy var weather: Weather = {        
        return Weather(latLng: self.latLng)
    }()
    
    func getTitle() ->String {
        return "\(city), \(country)"
    }
    
    func getSearchedTitle() ->String {
        return "\(city), \(region)"
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(latLng, forKey: "latLng")
        aCoder.encodeObject(city , forKey: "city")
        aCoder.encodeObject(region, forKey: "region")
        aCoder.encodeObject(country, forKey: "country")
        aCoder.encodeBool(isCurrent, forKey: "isCurrent")
//        aCoder.encodeBool(isSelected, forKey: "isSelected")
    }
    
    init(coder aDecoder: NSCoder!) {
        latLng =    aDecoder.decodeObjectForKey("latLng") as String
        city =      aDecoder.decodeObjectForKey("city") as String
        region =   aDecoder.decodeObjectForKey("region") as String
        country =   aDecoder.decodeObjectForKey("country") as String
//        isSelected = aDecoder.decodeBoolForKey("isSelected")
        isCurrent = aDecoder.decodeBoolForKey("isCurrent")
    }
    

}

func == (lhs: Location, rhs: Location) -> Bool {
    return lhs.latLng == rhs.latLng
}
