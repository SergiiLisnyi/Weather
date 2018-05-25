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
    
     var arrayCities: [City] = [] {
        didSet {
            updateView?()
        }
    }
   
    var arrayWeather = [ModelWeatherProtocol]()
    var updateView: (()->())?
    
    func getCityName(name: String, updateScreen: @escaping (Bool, String)->()) {
        let url = ApiData.BASE_URL_CITY + ApiData.APIKEY + "&q=" + name
        Request.request(url: url, complete: { data in
        let city = data[0]["EnglishName"].description
        self.isRepeat(name: city) ? updateScreen(false, "") :
                                    updateScreen(city != "null", city)
        })
    }
    
    func getWeatherModel(type: City) -> ModelWeatherProtocol {
        guard let name = type.name else { return ModelWeatherByLocation() }
        return ModelWeatherByCity(city: name)
    }
    
    func isRepeat(name: String) -> Bool {
        return arrayCities.contains(City(name: name))
    }
}

