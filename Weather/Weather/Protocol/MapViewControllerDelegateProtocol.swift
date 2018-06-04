//
//  MapViewControllerDelegateProtocol.swift
//  Weather
//
//  Created by Sergii Lisnyi on 6/4/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//

import Foundation

protocol  MapViewControllerDelegateProtocol {
    
    func getCityNameByLocation(latitude: String, longitude: String, complete: @escaping (Bool, String, String?)->())
    func addCity(cityName: String)
    
}
