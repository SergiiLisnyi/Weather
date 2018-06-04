//
//  CitiesViewControllerDelegate.swift
//  Weather
//
//  Created by Sergii Lisnyi on 6/4/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//

import Foundation

protocol CitiesViewControllerDelegateProtocol {
    
    func getCity() -> [(name: String, temp: String)]?
    func remove(at index: Int)
    func editOrder(from indexOutput: Int, to indexInsert: Int)

}

