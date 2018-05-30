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
    
     var arrayCities: [String] = [] {
        didSet {
            updateView?()
        }
    }
   
    var arrayWeather = [ModelWeatherProtocol]()
    var updateView: (()->())?
    
    func getCityName(name: String, updateScreen: @escaping (Bool, String)->()) {
        let url = ApiData.BASE_URL_CITY + ApiData.APIKEY + "&q=" + name
        Request.requestWithAlamofire(url: url, complete: { data in
            if data.isEmpty { return }
            let city = data[0]["EnglishName"].description
            self.isRepeat(name: city) ? updateScreen(false, "") :
                                    updateScreen(city != "null", city)
        })
    }
    
    func getCityNameByLocation(latitude: String, longitude: String, complete: @escaping (String)->()) {  
        let url = ApiData.BASE_URL_LOCATION + ApiData.APIKEY + "&q=" + latitude + "%2C" + longitude
        Request.requestWithAlamofire(url: url, complete: { data in
            if data.isEmpty { return }
            let cityName = data["ParentCity"]["EnglishName"].string
            cityName != nil ? complete(cityName!) : complete(data["EnglishName"].description)
        })
    }
    
    func getWeatherModel(name: String) -> ModelWeatherProtocol {
        if (name == "") {
            return ModelWeatherByLocation()
        }
        return ModelWeatherByCity(city: name)
    }
    
    func isRepeat(name: String) -> Bool {
        return arrayCities.contains(name)
    }
}

