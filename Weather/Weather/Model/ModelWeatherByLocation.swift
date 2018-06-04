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
   
    var weatherOnDay: ForecastWeatherDay?
    var weatherOnHours = [ForecastWeatherHourly](repeating: ForecastWeatherHourly(time: "", temp: ""), count: 12)
    let locationManager = CLLocationManager()
    var weatherOnFiveDays = [ForecastWeatherOnDays](repeating: ForecastWeatherOnDays(nameDay: "", minTempDay: "", maxTempDay: ""), count: 5)
    var cityName: String!
    var callBack: ((String?)->())?
    
    override init() {
        super.init()
        updateLocation()
    }
    
    func update(updateScreen: @escaping (String?)->Void) {
        callBack = updateScreen
        if isLoaded() { callBack?(nil) }
    }
    
    private func updateLocation() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } 
    }
    
    func getLocationKey(latitude: String, longitude: String, completion: @escaping (String, String?)->Void) {
        let url = ApiData.BASE_URL_LOCATION + ApiData.APIKEY + "&q=" + latitude + "%2C%20" + longitude
        Request.requestWithAlamofire(url: url, complete: { data, error  in
            if let error = error {
                completion("", error)
                return
            }
            if data.isEmpty { return }
            let locationKey = data["Key"].description
            self.cityName = data["ParentCity"]["EnglishName"].description
            completion(locationKey, error)
        })
    }
}

extension ModelWeatherByLocation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let latitude = String(locValue.latitude)
        let longitude = String(locValue.longitude)
        
        getLocationKey(latitude: latitude, longitude: longitude, completion: { locationKey, error  in
            if let error = error {
                self.callBack?(error)
                return
            }
            self.getWeatherOnFiveDay(keyCity: locationKey, updateScreen: self.callBack!)
            self.getWeatherOnHourly(city: self.cityName, keyCity: locationKey, updateScreen: self.callBack!)
        })
    }
}















