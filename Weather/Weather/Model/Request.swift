//
//  Request.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/24/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//
import SwiftyJSON
import Foundation

class Request {
    
    static func request(url: String, complete: @escaping (JSON)->Void) {
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { print("Returning error"); return }
            guard let content = data else { print("Not returning data") ; return }
            complete(JSON(content))
        }
        task.resume()
    }
}





