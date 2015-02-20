//
//  Forecast.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 20/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import Foundation

class Forecast : NSObject {
    
    var tempreatureC = WEATHER_NA
    var tempreatureF = WEATHER_NA
    var iconImage = UIImage()
    var iconCode : Int {
        set(code) {
            iconImage = UIImage(named: DI.context.weatherService.iconNameByCode(code))!
        }
        get {
            return 0
        }
    }
    var type = "Now available"
    var date = NSDate()
    var weekday = WEATHER_NA
    
    func tempreature(short:Bool) -> String
    {
        if ( DI.context.settings.tempreatureUnit == .Celsius ) {
            return tempreatureC +  ( short ?  "°" :"°C" )
        } else {
            return tempreatureF + ( short ?  "°" :"°F" )
        }
        
    }
    
    
    
    
    
}