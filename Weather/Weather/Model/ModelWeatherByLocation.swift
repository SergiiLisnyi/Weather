//
//  WeatherLocationModel.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/23/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//
import SwiftyJSON
import Foundation


import MapKit
import CoreLocation


class ModelWeatherByLocation: NSObject, ModelWeatherProtocol  {

    
    let locationManager = CLLocationManager()
    let days = 5
    var hourlyWeather = ForecastWeatherHourly()
    var daysWeather = [ForecastWeatherOnDays](repeating: ForecastWeatherOnDays(), count: 5)
    var latitude: String = ""
    var longitude: String = ""
    var delegate: (()->Void)?
    
    override init() {
        super.init()
        updateLocation()
        print("asdasdads")
    }
    
    
    
    func update(updateScreen: @escaping ()->Void) {
        delegate = updateScreen
    }
    
    
    fileprivate func updateLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            print("Location services not endabled")
        }
    }
    
    
    func getWeatherByLocation(latitude: String, longitude: String, updateScreen: @escaping ()->()) {
        let url = URL(string: ApiData.BASE_URL_LOCATION + ApiData.APIKEY + "&q=" + latitude + "%2C%20" + longitude)
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            guard error == nil else { print("returning error"); return }
            guard let content = data else { print("not returning data") ; return }
            let clearJSON = JSON(content)
            
            let city = clearJSON["ParentCity"]["EnglishName"].description
            let key = clearJSON["Key"].description
            self.getWeatherOnFiveDay(keyCity: key, updateScreen: updateScreen)
            self.getWeatherOnHourly(city: city, keyCity: key, updateScreen: updateScreen)
        }
        task.resume()
    }
    
    
    fileprivate func getWeatherOnFiveDay(keyCity: String, updateScreen: @escaping ()->())  {
        let url = URL(string: ApiData.BASE_URL + "daily/5day/" + keyCity + "?apikey=" + ApiData.APIKEY + "&metric=true")
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            guard error == nil else { print("returning error"); return }
            guard let content = data else { print("not returning data") ; return }
            let clearJSON = JSON(content)

            for i in 0..<self.days {
                let date = clearJSON["DailyForecasts"][i]["Date"].description
                let onlyDay = date[0 ..< 10]
                self.daysWeather[i].nameDay = ParserJSON.getDayOfWeek(onlyDay)
                self.daysWeather[i].minTempDay = clearJSON["DailyForecasts"][i]["Temperature"]["Minimum"]["Value"].description
                self.daysWeather[i].maxTempDay = clearJSON["DailyForecasts"][i]["Temperature"]["Maximum"]["Value"].description
            }
            updateScreen()
        }
        task.resume()
    }

    fileprivate func getWeatherOnHourly(city: String, keyCity: String, updateScreen: @escaping ()->())  {
        let url = URL(string: ApiData.BASE_URL + "hourly/12hour/" + keyCity + "?apikey=" + ApiData.APIKEY + "&metric=true")
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            guard error == nil else { print("returning error"); return }
            guard let content = data else { print("not returning data") ; return }
            let clearJSON = JSON(content)

            self.hourlyWeather = ForecastWeatherHourly(city: city,
                                                       tempCurrent: clearJSON[0]["Temperature"]["Value"].description + "°",
                                                       arrayTemp: ParserJSON.getTempHourly(json: clearJSON))
            updateScreen()
        }
        task.resume()
    }
}


extension ModelWeatherByLocation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let latitude = String(locValue.latitude)
        let longitude = String(locValue.longitude)
        
        print("func")
        print(delegate)
        getWeatherByLocation(latitude: latitude, longitude: longitude, updateScreen: delegate!)

    }
}















