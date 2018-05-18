//
//  ForecastWeatherHourtlyModel.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/18/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//

import Foundation

struct ForecastWeatherHourly {
    var city: String?
    var tempCurrent: String?
    var arrayTempHourly = [String]()
    var arrayTimeHourly = [String]()
}
