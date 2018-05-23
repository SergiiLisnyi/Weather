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
    
    var hourlyWeather = ForecastWeatherHourly()
    let days = 5
    var daysWeather = [ForecastWeatherOnDays](repeating: ForecastWeatherOnDays(), count: 5)
    var cityName: String
    
    init(city: String) {
        self.cityName = city
    }

    func update(updateScreen: @escaping ()->Void) {
        getWeatherByCity(name: cityName, updateScreen: updateScreen)
    }
    
    
    func getWeatherByCity(name: String, updateScreen: @escaping ()->()) {
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
            
            for i in 0..<self.days {
                let date = clearJSON["DailyForecasts"][i]["Date"].description
                let onlyDay = date[0 ..< 10]
                self.daysWeather[i].nameDay = ParserJSON.getDayOfWeek(onlyDay)
                self.daysWeather[i].minTempDay = clearJSON["DailyForecasts"][i]["Temperature"]["Minimum"]["Value"].description
                self.daysWeather[i].maxTempDay = clearJSON["DailyForecasts"][i]["Temperature"]["Maximum"]["Value"].description
            }
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
                                                       arrayTemp: ParserJSON.getTempHourly(json: clearJSON))
            
            
            updateScreen()
        }
        task.resume()
    }
}
