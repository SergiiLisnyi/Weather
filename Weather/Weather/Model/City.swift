//
//  TypeInput.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/25/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//

import Foundation

struct City {
    var name: String?
}

extension City: Equatable {
    static func == (lhs: City, rhs: City) -> Bool {
       return lhs.name == rhs.name
    }
}
