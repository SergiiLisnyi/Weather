//
//  TypeInputData.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/18/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//

import Foundation

enum TypeInputData {
    case city(name: String)
    case location()
}

extension TypeInputData: Equatable {
    static func == (lhs: TypeInputData, rhs: TypeInputData) -> Bool {
        switch (lhs, rhs) {
        case (city(let lName), city(let rName)):
            return lName == rName
        default:
            return false
        }
    }
}

