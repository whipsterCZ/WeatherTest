//
//  Weather.swift
//  WeatherTest
//
//  Created by Daniel Kouba on 16/02/15.
//  Copyright (c) 2015 Daniel Kouba. All rights reserved.
//

import Foundation


class Weather : NSObject
{
    
    var url: String
    var tempreature:String?
    
    init(url:String) {
        self.url = url
    }
    
    
    
}