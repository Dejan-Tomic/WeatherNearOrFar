//
//  ViewController.swift
//  WeatherNearOrFar
//
//  Created by Dejan Tomic 01/09/2019
//  Copyright (c) 2015 Dejan Tomic. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let UVINDEX_URL = "http://api.openweathermap.org/data/2.5/uvi"
    let APP_ID = "23496c1b7f950b92e55c4e72c87e12f6"
    
    //Instance variables
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    @IBOutlet weak var backgroundImageWeather: UIImageView!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var uvIndexLabel: UILabel!
    
    @IBOutlet weak var celciusFahrenheitSegementedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Set up the location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url: String, parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the weather data")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                print("Error \(response.result.error)")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json: JSON) {
       
        if let tempResult = json["main"]["temp"].double, let humidityResult = json["main"]["humidity"].double {
        
        weatherDataModel.temperature = Int(tempResult - 273.15)
        
        weatherDataModel.humidity = Int(humidityResult)
            
       // weatherDataModel.uvIndex = Int(uvIndexResult)
        
        weatherDataModel.city = json["name"].stringValue
        
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        
        weatherDataModel.weatherBackgroundName = weatherDataModel.updateBackgroundImage(condition: weatherDataModel.condition)

        
        updateUIWithWeatherData()
        } else {
            cityLabel.text = "Weather Unavailble"
        }
    }
    
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°C"
        humidityLabel.text = "\(weatherDataModel.humidity)%"
        uvIndexLabel.text = "\(weatherDataModel.uvIndex)"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        backgroundImageWeather.image = UIImage(named: weatherDataModel.weatherBackgroundName)
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params: [String: String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
           // getWeatherData(url: UVINDEX_URL, parameters: params)

        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    
    
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredANewCityName(city: String) {
        let params: [String : String] = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    
    //Write the PrepareForSegue Method here
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
        } 
    }
    
    @IBAction func celciusToFahrenheitConverter(_ sender: Any) {
        var currentTemperature: Int = 0
        switch celciusFahrenheitSegementedControl.selectedSegmentIndex {
        case 0:
            currentTemperature = weatherDataModel.temperature
            temperatureLabel.text = "\(currentTemperature)°C"
        case 1: 
            currentTemperature = (weatherDataModel.temperature * 9/5) + 32
            temperatureLabel.text = "\(currentTemperature)°F"
        default:
            currentTemperature = weatherDataModel.temperature
            temperatureLabel.text = "\(currentTemperature)°C"
        }
    }
    

}


