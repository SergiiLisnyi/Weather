//
//  ModelProtocol.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/23/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//
import SwiftyJSON
import Foundation

protocol ModelWeatherProtocol : class {
    
    var hourlyWeather: ForecastWeatherHourly? { get set }
    var daysWeather: [ForecastWeatherOnDays] { get set }
    
    func update(updateScreen: @escaping ()->Void)
}

extension ModelWeatherProtocol  {
    
    var days: Int {
       return 5
    }

    func isLoad() -> Bool {
        return hourlyWeather != nil
    }
    
    func getWeatherOnFiveDay(keyCity: String, updateScreen: @escaping ()->())  {
        let url = ApiData.BASE_URL + "daily/5day/" + keyCity + "?apikey=" + ApiData.APIKEY + "&metric=true"
        Request.request(url: url, complete: { data in
            for i in 0..<self.days {
                let date = data["DailyForecasts"][i]["Date"].description
                let onlyDay = date[0 ..< 10]
                self.daysWeather[i].nameDay = ParserJSON.getDayOfWeek(onlyDay)
                self.daysWeather[i].minTempDay = data["DailyForecasts"][i]["Temperature"]["Minimum"]["Value"].description
                self.daysWeather[i].maxTempDay = data["DailyForecasts"][i]["Temperature"]["Maximum"]["Value"].description
            }
            updateScreen()
        })
    }
    
    func getWeatherOnHourly(city: String, keyCity: String, updateScreen: @escaping ()->())  {
        let url = ApiData.BASE_URL + "hourly/12hour/" + keyCity + "?apikey=" + ApiData.APIKEY + "&metric=true"
        Request.request(url: url, complete: { data in
            self.hourlyWeather = ForecastWeatherHourly(city: city,
                                                       tempCurrent: data[0]["Temperature"]["Value"].description + "°",
                                                       arrayTemp: ParserJSON.getTempHourly(json: data))
            updateScreen()
        })
    }   
}
