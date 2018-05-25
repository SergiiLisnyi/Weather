//
//  ParserJSON.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/18/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//
import SwiftyJSON
import Foundation


class ParserJSON {
    
    static let hours = 12
    static let midnight = 24
    
    static func getDayOfWeek(_ today:String) -> String {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: todayDate).capitalized
    }
    
    static func getTempHourly(json: JSON) -> [(time: String, temp: String)] {
        var result = [(time: String, temp: String)]()
        let time = json[0]["DateTime"].description
        var hour = Int(time[11 ..< 13]) ?? 0
        for i in 0..<hours {
            hour = hour + 1
            if hour == midnight { hour = 0 }
            result.append((String(hour), json[i]["Temperature"]["Value"].description))
        }
        return result
    }
    
}
