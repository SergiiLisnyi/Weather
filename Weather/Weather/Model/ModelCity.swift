//
//  CityModel.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/18/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//
import SwiftyJSON
import Foundation

class ModelCity {
    
    init()  {
    }
    
    var arrayCities: [TypeInputData] = [] {
        didSet {
            updateView?()
        }
    }
   
    var arrayWeather = [ModelWeatherProtocol]()
    var updateView: (()->Void)?
    
    func getCityName(name: String, updateScreen: @escaping (Bool, String)->()) {
        let url = ApiData.BASE_URL_CITY + ApiData.APIKEY + "&q=" + name
        Request.request(url: url, complete: { data in
        let city = data[0]["EnglishName"].description
        self.isRepeat(name: city) ? updateScreen(false, "") :
                                    updateScreen(city != "null", city)
        })
    }

    func getWeatherModel(type: TypeInputData) -> ModelWeatherProtocol {
        switch type {
        case .city(let name):
            return ModelWeatherByCity(city: name)
        case .location():
            return ModelWeatherByLocation()
        }
    }
    
    func isRepeat(name: String) -> Bool {
       return arrayCities.contains(TypeInputData.city(name: name))
    }
}

