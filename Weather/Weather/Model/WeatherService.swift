//
//  WeatherModel.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/15/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//
import SwiftyJSON
import Foundation

class WeatherService {
    
    var hourlyWeather = ForecastWeatherHourly()
    var daysWeather = ForecastWeatherOnDays()

    
    func getWeather(latitude: String, longitude: String, updateScreen: @escaping ()->()) {
        let url = URL(string: ApiData.BASE_URL_LOCATION + ApiData.APIKEY + "&q=" + latitude + "%2C%20" + longitude)
        
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            guard error == nil else { print("returning error"); return }
            guard let content = data else { print("not returning data") ; return }
            let clearJSON = JSON(content)
            
            let city = clearJSON["ParentCity"]["EnglishName"].description
            let key = clearJSON["Key"].description
            
            self.getWeatherOnFiveDay(keyCity: key, updateScreen: updateScreen)
            self.getWeatherOnHourly(city: city, keyCity: key, updateScreen: updateScreen)
        }
        task.resume()
    }
    
    
    func getWeatherName(name: String, updateScreen: @escaping ()->()) {
        let url = URL(string: ApiData.BASE_URL_CITY + ApiData.APIKEY + "&q=" + name)
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            guard error == nil else { print("returning error"); return }
            guard let content = data else { print("not returning data") ; return }
            let clearJSON = JSON(content)
            
            let city = clearJSON[0]["EnglishName"].description
            let key = clearJSON[0]["Key"].description

            self.getWeatherOnFiveDay(keyCity: key, updateScreen: updateScreen)
            self.getWeatherOnHourly(city: city, keyCity: key, updateScreen: updateScreen)
        }
        task.resume()
    }
    
    
    fileprivate func getWeatherOnFiveDay(keyCity: String, updateScreen: @escaping ()->())  {
        let url = URL(string: ApiData.BASE_URL + "daily/5day/" + keyCity + "?apikey=" + ApiData.APIKEY + "&metric=true")
        
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            guard error == nil else { print("returning error"); return }
            guard let content = data else { print("not returning data") ; return }
            let clearJSON = JSON(content)

            self.daysWeather = ForecastWeatherOnDays(arrayNameDay: ParserJSON.getNameDay(json: clearJSON),
                                  arrayMinTempDay: ParserJSON.getMinTempDay(json: clearJSON),
                                  arrayMaxTempDay: ParserJSON.getMaxTempDay(json: clearJSON))
            updateScreen()
        }
        task.resume()
    }

    
    fileprivate func getWeatherOnHourly(city: String, keyCity: String, updateScreen: @escaping ()->())  {

        let url = URL(string: ApiData.BASE_URL + "hourly/12hour/" + keyCity + "?apikey=" + ApiData.APIKEY + "&metric=true")
        
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            guard error == nil else { print("returning error"); return }
            guard let content = data else { print("not returning data") ; return }
            let clearJSON = JSON(content)
            
            self.hourlyWeather = ForecastWeatherHourly(city: city,
                                                       tempCurrent: clearJSON[0]["Temperature"]["Value"].description + "°",
                                                       arrayTempHourly: ParserJSON.getTempHourly(json: clearJSON),
                                                       arrayTimeHourly: ParserJSON.getTime(json: clearJSON))
            updateScreen()
        }
        task.resume()
    }
}

