//
//  Endpoint+URL.swift
//  WeatherApp
//
//  Created by MacBook Air on 19.08.2023.
//

import Foundation

extension Endpoint {
    static let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure("Wrong url components.")
        }
        return url
    }
}
