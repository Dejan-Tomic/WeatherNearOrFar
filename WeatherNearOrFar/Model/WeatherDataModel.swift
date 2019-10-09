//
//  WeatherDataModel.swift
//  WeatherNearOrFar
//
//  Created by Dejan Tomic 01/09/2019
//  Copyright (c) 2015 Dejan Tomic. All rights reserved.
//

import UIKit

class WeatherDataModel {
    
    // model variables
    var temperature: Int = 0
    var humidity: Int = 0
    var condition: Int = 0
    var uvIndex: Int = 0
    var city: String = ""
    var weatherIconName: String = ""
    var weatherBackgroundName: String = ""
    
    //This method turns a condition code into the name of the weather condition image
    
        func updateWeatherIcon(condition: Int) -> String {
    
        switch (condition) {
    
            case 0...300 :
                return "tstorm1"
    
            case 301...500 :
                return "light_rain"
    
            case 501...600 :
                return "shower3"
    
            case 601...700 :
                return "snow4"
    
            case 701...771 :
                return "fog"
    
            case 772...799 :
                return "tstorm3"
    
            case 800 :
                return "sunny"
    
            case 801...804 :
                return "cloudy2"
    
            case 900...903, 905...1000  :
                return "tstorm3"
    
            case 903 :
                return "snow5"
    
            case 904 :
                return "sunny"
    
            default :
                return "dunno"
            }
    
        }
    
    //This method turns a condition code into the name of the weather background image
    
    func updateBackgroundImage(condition: Int) -> String {
        
        switch (condition) {
        // thunderstorms
        case 0...299 :
            return "storm"
            
        // Drizle & light rain
        case 300...531 :
            return "rain"
        
        // snow
        case 601...700 :
            return "snow"
        
        // fog
        case 701...771 :
            return "foggyday"
        
        // thunderstorms
        case 772...799 :
            return "storm"
            
        // sunny
        case 800 :
            return "sunnyday"
            
        // cloudy
        case 801...804 :
            return "cloud"
        
            
        // thunderstorms again
        case 900...903, 905...1000  :
            return "storm"
        
        // snow again
        case 903 :
            return "snow"
        
        // sunny
        case 904 :
            return "sunny"
            
        default :
            return "rain"
        }
        
    }
}
