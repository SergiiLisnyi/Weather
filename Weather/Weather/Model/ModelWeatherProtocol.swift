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

