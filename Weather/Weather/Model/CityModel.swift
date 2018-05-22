//
//  CityModel.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/18/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//
import SwiftyJSON
import Foundation


//struct DataModel {
//
//    var city: TypeInputData
//    var forecast: WeatherService?
//
//}

class CityModel {
    
    var arrayCity = [TypeInputData]()
    
    func getCityName(name: String, updateScreen: @escaping (Bool)->()) {
        let url = URL(string: ApiData.BASE_URL_CITY + ApiData.APIKEY + "&q=" + name)
        let task = URLSession.shared.dataTask(with: url!) {
        (data, response, error) in
        guard error == nil else { print("returning error"); return }
        guard let content = data else { print("not returning data") ; return }
        let clearJSON = JSON(content)
        let city = clearJSON[0]["EnglishName"].description
        updateScreen(city != "null")
        }
        task.resume()
    }
}

