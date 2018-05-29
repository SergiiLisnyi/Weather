//
//  WeatherCityModel.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/23/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//
import SwiftyJSON
import Foundation

class ModelWeatherByCity: ModelWeatherProtocol {
   
    var hourlyWeather: ForecastWeatherHourly?
    var daysWeather = [ForecastWeatherOnDays](repeating: ForecastWeatherOnDays(), count: 5)
    var cityName: String!
    
    init(city: String) {
        self.cityName = city
    }

    func update(updateScreen: @escaping ()->Void) { 
        if !isLoad() {
            getLocationKey(name: cityName, complete: { locationKey in
                self.getWeatherOnFiveDay(keyCity: locationKey, updateScreen: updateScreen)
                self.getWeatherOnHourly(city: self.cityName, keyCity: locationKey, updateScreen: updateScreen)
            })
        }
        else {
            updateScreen()
        }
    }

    func getLocationKey(name: String, complete: @escaping (String)->Void) {
        let url = ApiData.BASE_URL_CITY + ApiData.APIKEY + "&q=" + name
        Request.requestWithAlamofire(url: url, complete: { data in
            let locationKey = data[0]["Key"].description
            self.cityName = data[0]["EnglishName"].description
            complete(locationKey)
        })
    }
}
