//
//  CityModel.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/18/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//
import SwiftyJSON
import Foundation

class ModelCities {

    var cities =  [String]()
    var modelsWeather = [ModelWeatherProtocol]()
    var updateView: ((Operation)->())?
    
    func remove(at: Int) {
        modelsWeather.remove(at: at)
        cities.remove(at: at)
        updateView?(.edit)
    }
    
    func addCity(cityName: String) {
        cities.append(cityName)
        updateView?(.add)
    }
    
    func editOrder(from: Int, to: Int) {
        let itemCity = cities[from]
        let itemWeather = modelsWeather[from]
        cities.remove(at: from)
        modelsWeather.remove(at: from)
        cities.insert(itemCity, at: to)
        modelsWeather.insert(itemWeather, at: to)
        updateView?(.edit)
    }

    func getCity() -> [(name: String, temp: String)]? {
        var result = [(name: String, temp: String)]()
        for i in 0..<modelsWeather.count {
            guard let data = modelsWeather[i].weatherOnDay else { return nil }
            result.append((modelsWeather[i].cityName, data.tempCurrent))
        }
        return result
    }
    
    func getCityNameByLocation(latitude: String, longitude: String, complete: @escaping (Bool, String)->()) {
        let url = ApiData.BASE_URL_LOCATION + ApiData.APIKEY + "&q=" + latitude + "%2C" + longitude
        Request.requestWithAlamofire(url: url, complete: { data in
            if data.isEmpty { return }
            var cityName = data["ParentCity"]["EnglishName"].string
            if cityName == nil {
                cityName = data["EnglishName"].description
            }
            self.isRepeat(name: cityName!) ? complete(false, cityName!) : complete(true, cityName!)
            })
    }

    func getWeatherModel(name: String) -> ModelWeatherProtocol {
        if (name == "") { return ModelWeatherByLocation() }
        return ModelWeatherByCity(city: name)
    }
    
    func isRepeat(name: String) -> Bool {
        return cities.contains(name)
    }
}

