//
//  NetworkError.swift
//  WeatherApp
//
//  Created by MacBook Air on 19.08.2023.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case custom(String)
    case emptyData
    case wrongJson(String)
    case wrongURL
    case wrongParameters

    var description: String {
        switch self {
        case .custom(let text):
            return text
        case .emptyData:
            return "empty data"
        case .wrongJson(let json):
            return "wrong json - \(json)"
        case .wrongURL:
            return "wrong URL"
        case .wrongParameters:
            return "wrong params"
        }
    }
}
