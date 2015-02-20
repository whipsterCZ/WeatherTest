//
//  Weather.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 16/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import Foundation

let WEATHER_NA = " "

class Weather : NSObject
{
    
    var latLng: String
    var type = "Now available"
    var tempreatureC = WEATHER_NA
    var tempreatureF = WEATHER_NA
    var iconImageBig = UIImage()
    var iconImage = UIImage()
    var iconCode : Int {
        set(code) {
            iconImageBig = UIImage(named: DI.context.weatherService.iconNameByCode(code, big:true))!
            iconImage = UIImage(named: DI.context.weatherService.iconNameByCode(code))!
        }
        get {
            return 0
        }
    }
    var rainPercentage =    WEATHER_NA
    var rainAmmountMm: Float?
    var windDirection =     WEATHER_NA
    var windSpeedMetric = WEATHER_NA
    var windSpeedImperial = WEATHER_NA
    var forecastList = [Forecast]()
    
    var lastUpdated:NSDate?
    
    init(latLng:String) {
        self.latLng = latLng
        super.init()
        fetchWeather()

    }
   
    func fetchWeather()
    {
        
        let updateInterval = (DI.context.getParameter("weather_update_interval", defaultValue: "1800")! as NSString).doubleValue
        
        if ( lastUpdated == nil ||  lastUpdated!.timeIntervalSinceNow > updateInterval) {
           DI.context.weatherService.fetchWeather(self)            
        }
    }
    
    func weatherDidUpdate() {
        
        lastUpdated = NSDate()
        NSNotificationCenter.defaultCenter().postNotificationName(RELOAD_NOTIFICATION, object: self)
        
    }
    

    func fahrenheit(celsius: Float) -> Float
    {
        return (celsius * 1.8) + 32.0
    }
    
    func inches(meters:Float) ->Float
    {
        return meters * 39.3701
    }
    
    func miles(km:Float) -> Float
    {
        return km * 0.621371
    }
    
    func tempreature(short:Bool) -> String
    {
        if ( DI.context.settings.tempreatureUnit == .Celsius ) {
            return tempreatureC +  ( short ?  "°" :"°C" )
        } else {
            return tempreatureF + ( short ?  "°" :"°F" )
        }
        
    }
    
    func windSpeed() -> String
    {
        if ( DI.context.settings.lengthUnit == .Metric ) {
            return windSpeedMetric + " m"
        } else {
            return windSpeedImperial + " ml"
        }
    }
    
    func rainAmmount() ->String
    {
        if ( rainAmmountMm != nil) {
            if ( DI.context.settings.lengthUnit == .Metric ) {
                return "\(rainAmmountMm!) mm"
            } else {
                var rainAmmountInches = inches(rainAmmountMm!/1000)
                return "\(rainAmmountInches) in"
            }
        }
        return WEATHER_NA
    }
    
    func summary()->String
    {
        return tempreature(false) + " " + type
    }
    
    
    
    
    
    
    
        
}