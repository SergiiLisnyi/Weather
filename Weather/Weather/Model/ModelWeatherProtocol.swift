//
//  ModelProtocol.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/23/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//
import SwiftyJSON
import Foundation

protocol ModelWeatherProtocol {
    
    var hourlyWeather: ForecastWeatherHourly { get set }
    var daysWeather: [ForecastWeatherOnDays] { get set }
    
    func update(updateScreen: @escaping ()->Void)
}

//extension ModelProtocol {
//
//    //let days = 5
//    
//    mutating func getWeatherOnFiveDay(keyCity: String, updateScreen: @escaping ()->())  {
//        let url = URL(string: ApiData.BASE_URL + "daily/5day/" + keyCity + "?apikey=" + ApiData.APIKEY + "&metric=true")
//        let task = URLSession.shared.dataTask(with: url!) {
//            (data, response, error) in
//            guard error == nil else { print("returning error"); return }
//            guard let content = data else { print("not returning data") ; return }
//            let clearJSON = JSON(content)
//            
//            for i in 0..<5 {
//                let date = clearJSON["DailyForecasts"][i]["Date"].description
//                let onlyDay = date[0 ..< 10]
//                daysWeather[i].nameDay = ParserJSON.getDayOfWeek(onlyDay)
//                daysWeather[i].minTempDay = clearJSON["DailyForecasts"][i]["Temperature"]["Minimum"]["Value"].description
//                daysWeather[i].maxTempDay = clearJSON["DailyForecasts"][i]["Temperature"]["Maximum"]["Value"].description
//            }
//            updateScreen()
//        }
//        task.resume()
//    }
//    
//    mutating func getWeatherOnHourly(city: String, keyCity: String, updateScreen: @escaping ()->())  {
//        let url = URL(string: ApiData.BASE_URL + "hourly/12hour/" + keyCity + "?apikey=" + ApiData.APIKEY + "&metric=true")
//        let task = URLSession.shared.dataTask(with: url!) {
//            (data, response, error) in
//            guard error == nil else { print("returning error"); return }
//            guard let content = data else { print("not returning data") ; return }
//            let clearJSON = JSON(content)
//            
//            self.hourlyWeather = ForecastWeatherHourly(city: city,
//                                                       tempCurrent: clearJSON[0]["Temperature"]["Value"].description + "°",
//                                                       arrayTemp: ParserJSON.getTempHourly(json: clearJSON))
//            updateScreen()
//        }
//        task.resume()
//    }
//}
