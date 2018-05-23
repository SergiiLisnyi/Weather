//
//  CityModel.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/18/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//
import SwiftyJSON
import Foundation

class CityModel {
    
    var arrayCity = [TypeInputData]()
    
    func getCityName(name: String, updateScreen: @escaping (Bool, String)->()) {
        let url = URL(string: ApiData.BASE_URL_CITY + ApiData.APIKEY + "&q=" + name)
        let task = URLSession.shared.dataTask(with: url!) {
        (data, response, error) in
        guard error == nil else { print("returning error"); return }
        guard let content = data else { print("not returning data") ; return }
        let clearJSON = JSON(content)
        let city = clearJSON[0]["EnglishName"].description
        updateScreen(city != "null", city)
        }
        task.resume()
    }
    
    func getModel(type: TypeInputData) -> ModelWeatherProtocol {
        switch type {
        case .city(let name):
            return ModelWeatherByCity(city: name)
        case .location(let latitude, let longitude):
            return ModelWeatherByLocation(latitude: latitude, longitude: longitude)
            
        }
    }
    
}

