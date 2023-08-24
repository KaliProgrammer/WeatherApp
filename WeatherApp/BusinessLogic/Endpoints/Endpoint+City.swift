//
//  Endpoint+City.swift
//  WeatherApp
//
//  Created by MacBook Air on 19.08.2023.
//

import Foundation

extension Endpoint {
    
    static func city(name: String, value: String) -> Self {
        let apiKey = Apikey()
        return Endpoint(queryItems: [
        URLQueryItem(name: name, value: value),
        URLQueryItem(name: "APPID", value: apiKey.apiKey)
        ])
    }
}

