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

    var weatherOnDay: ForecastWeatherDay?
    var weatherOnHours = [ForecastWeatherHourly](repeating: ForecastWeatherHourly(time: "", temp: ""), count: 12)
    var weatherOnFiveDays = [ForecastWeatherOnDays](repeating: ForecastWeatherOnDays(nameDay: "", minTempDay: "", maxTempDay: ""), count: 5)
    var cityName: String!
    
    init(city: String) {
        self.cityName = city
    }

    func update(updateScreen: @escaping (String?)->Void) {
        if !isLoaded() {
            getLocationKey(name: cityName, completion: { locationKey in
                self.getWeatherOnFiveDay(keyCity: locationKey, updateScreen: updateScreen)
                self.getWeatherOnHourly(city: self.cityName, keyCity: locationKey, updateScreen: updateScreen)
            })
        }
        else {
            updateScreen(nil)
        }
    }

    func getLocationKey(name: String, completion: @escaping (String)->Void) {
        var parcedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        parcedName = parcedName.replacingOccurrences(of: " ", with: "%20")
        let url = ApiData.BASE_URL_CITY + ApiData.APIKEY + "&q=" + parcedName
        Request.requestWithAlamofire(url: url, complete: { data, error  in
            if data.isEmpty { return }
            let locationKey = data[0]["Key"].description
            self.cityName = data[0]["EnglishName"].description
            completion(locationKey)
        })
    }
}
