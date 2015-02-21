//
//  WeatherAPI.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 14/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import Foundation


class WeatherService
{

    var apiUrl : String
    var apiKey : String
    
    var connectionManager = AFHTTPRequestOperationManager()
    
    init(apiUrl:String, apiKey:String) {
        self.apiUrl = apiUrl
        self.apiKey = apiKey
        
        NSLog("init weather")
        
    }
    
    
    func iconNameByCode(code:Int, big: Bool = false) -> String {
        
        let postfix = big ? "_Big" : ""
        
        switch code {
        case 300...500,200  :   return "Lightning"+postfix
        case 200...299:         return "Wind"+postfix
        case 0...118:           return "Sun"+postfix
        default:                return "Cloudy"+postfix
        }
        
        
    }
    
    
    //MARK: - Weather API
    func fetchWeather(weather: Weather) {
        
        var params = [
            "key": apiKey,
            "q" : weather.latLng,
            "format": "json",
            "fx": "true", //forecast
            "num_of_days": 7,
            "tp": 24, //day average for forcast
            
        ]
        
        connectionManager.GET(apiUrl, parameters: params, success: { (request, response) -> Void in
            
            weather.weatherStartUpdate()
            if let root = response as? NSDictionary {
                if let data = root["data"] as? NSDictionary
                {
                    if let error = root["error"] as? NSArray {
                        //no match
                        weather.isFetching = false
                        return
                    }
                    
                    if  let current_conditions = data["current_condition"] as? [NSDictionary] {
                        if let current = current_conditions.first {
                            
                            weather.tempreatureC =  current["temp_C"] as String
                            weather.tempreatureF =  current["temp_F"] as String
                            weather.type = (current["weatherDesc"] as [NSDictionary]).first!["value"] as String
                            weather.iconCode = (current["weatherCode"] as String).toInt()!
                            weather.windDirection = current["winddir16Point"] as String
                            weather.windSpeedMetric = current["windspeedKmph"] as String
                            weather.windSpeedImperial = current["windspeedMiles"] as String
                            weather.rainAmmountMm = (current["precipMM"] as NSString).floatValue
                            weather.rainPercentage = (current["cloudcover"] as String) + "%"
                            
                        }
                    }
                    
                    if let forecasts = data["weather"] as? [NSDictionary] {
                        
                        var dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        var dayFormatter = NSDateFormatter()
                        dayFormatter.dateFormat = "EEEE"
                        
//                        weather.forecastList = [Forecast]()
                        
                        for forecast in forecasts {
                            
                            var forecastDay = Forecast()
                            forecastDay.date = dateFormatter.dateFromString(forecast["date"] as String)!
                            forecastDay.weekday = dayFormatter.stringFromDate(forecastDay.date)
                            
                            
                            //Hourly contains whole day average due to param "tp"
                            if let hours = forecast["hourly"] as? [NSDictionary] {
                                if let current = hours.first {
                                    forecastDay.tempreatureC =  current["tempC"] as String
                                    forecastDay.tempreatureF =  current["tempF"] as String
                                    forecastDay.type = (current["weatherDesc"] as [NSDictionary]).first!["value"] as String
                                    forecastDay.iconCode = (current["weatherCode"] as String).toInt()!
                                }
                            }
                            weather.forecastList.append(forecastDay)
                        }
                    }    
                    weather.weatherDidUpdate()
                    
                }
            }
            
            
            }) { (request, error) -> Void in
                NSLog("AFNetworking Error: Weather API did not responded ")
        }
        
    }
    


}
