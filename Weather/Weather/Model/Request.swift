//
//  Request.swift
//  Weather
//
//  Created by Sergii Lisnyi on 5/24/18.
//  Copyright © 2018 Sergii Lisnyi. All rights reserved.
//
import SwiftyJSON
import Foundation
import Alamofire

class Request {
    
    static func request(url: String, complete: @escaping (JSON)->Void) {
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { print("Returning error"); return }
            guard let content = data else { print("Not returning data") ; return }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            if (200 ... 299).contains(httpResponse.statusCode) {
                complete(JSON(content))
            } else {
                print("error request , status code = \(httpResponse.statusCode) , url = \(url)")
            }
        }
        task.resume()
    }

    static func requestWithAlamofire (url: String, complete: @escaping (JSON)->Void) {
        guard let url = URL(string: url) else { return }
        Alamofire.request(url)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
            guard response.result.isSuccess else {
                print("Error \(String(describing: response.result.error))")
                return
            }
            guard let content = response.data else { return }
            complete(JSON(content))
        }
    }
}






