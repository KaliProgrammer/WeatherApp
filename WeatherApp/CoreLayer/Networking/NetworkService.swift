//
//  NetworkService.swift
//  WeatherApp
//
//  Created by MacBook Air on 19.08.2023.
//

import Foundation
import Combine

protocol NetworkSettings: AnyObject {
    func fetchData<T: Codable>(url: URL) -> AnyPublisher<T, Error>
}

class NetworkService: NetworkSettings {
    func fetchData<T: Codable>(url: URL) -> AnyPublisher<T, Error> {
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
