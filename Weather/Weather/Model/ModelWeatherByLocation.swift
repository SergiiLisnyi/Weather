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
   
    var hourlyWeather: ForecastWeatherHourly?
    let locationManager = CLLocationManager()
    var daysWeather = [ForecastWeatherOnDays](repeating: ForecastWeatherOnDays(), count: 5)
    var latitude = ""
    var longitude = ""
    var cityName: String!
    var delegate: (()->Void)?
    
    override init() {
        super.init()
        updateLocation()
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
        } 
    }
    
    func getLocationKey(latitude: String, longitude: String, complete: @escaping (String)->Void) {
        let url = ApiData.BASE_URL_LOCATION + ApiData.APIKEY + "&q=" + latitude + "%2C%20" + longitude
        Request.request(url: url, complete: { data in
            let locationKey = data["Key"].description
            self.cityName = data["ParentCity"]["EnglishName"].description
            complete(locationKey)
        })
    }
}

extension ModelWeatherByLocation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let latitude = String(locValue.latitude)
        let longitude = String(locValue.longitude)
        
        getLocationKey(latitude: latitude, longitude: longitude, complete: { locationKey in
                        self.getWeatherOnFiveDay(keyCity: locationKey, updateScreen: self.delegate!)
                        self.getWeatherOnHourly(city: self.cityName, keyCity: locationKey, updateScreen: self.delegate!)
        })
    }
}















