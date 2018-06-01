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
    
    var weatherOnDay: ForecastWeatherDay? { get set }
    var weatherOnHours: [ForecastWeatherHourly] { get set }
    var weatherOnFiveDays: [ForecastWeatherOnDays] { get set }
    var cityName: String! { get set }
    
    func update(updateScreen: @escaping ()->Void)
}

extension ModelWeatherProtocol  {
    
    var days: Int {
       return 5
    }

    var hourly: Int {
        return 12
    }
    
    var midNight: Int {
        return 24
    }
    
    func isLoaded() -> Bool {
        return weatherOnDay != nil
    }
    
    func getWeatherOnFiveDay(keyCity: String, updateScreen: @escaping ()->())  {
        let url = ApiData.BASE_URL + "daily/5day/" + keyCity + "?apikey=" + ApiData.APIKEY + "&metric=true"
        Request.requestWithAlamofire(url: url, complete: { data in
            for i in 0..<self.days {
                let date = data["DailyForecasts"][i]["Date"].description
                let onlyDay = date[0 ..< 10]
                self.weatherOnFiveDays[i].nameDay = ParserJSON.getDayOfWeek(onlyDay)
                self.weatherOnFiveDays[i].minTempDay = data["DailyForecasts"][i]["Temperature"]["Minimum"]["Value"].description
                self.weatherOnFiveDays[i].maxTempDay = data["DailyForecasts"][i]["Temperature"]["Maximum"]["Value"].description
            }
            updateScreen()
        })
    }
    
    func getWeatherOnHourly(city: String, keyCity: String, updateScreen: @escaping ()->())  {
        let url = ApiData.BASE_URL + "hourly/12hour/" + keyCity + "?apikey=" + ApiData.APIKEY + "&metric=true"
        Request.requestWithAlamofire(url: url, complete: { data in

            self.weatherOnDay = ForecastWeatherDay(
                                                       tempCurrent: data[0]["Temperature"]["Value"].description + "°")
            let time = data[0]["DateTime"].description
            var hour = Int(time[11 ..< 13]) ?? 0
            for i in 0..<self.hourly {
                hour = hour + 1
                if hour == self.midNight { hour = 0 }
                self.weatherOnHours[i].temp = data[i]["Temperature"]["Value"].description
                self.weatherOnHours[i].time = String(hour)
            }
            updateScreen()
        })
    }
}
