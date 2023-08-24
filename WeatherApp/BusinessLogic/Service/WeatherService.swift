//
//  WeatherService.swift
//  WeatherApp
//
//  Created by MacBook Air on 19.08.2023.
//

import Foundation
import Combine

protocol WeatherSetting {
    var networkService: NetworkSettings { get }
    func fetchData(by city: String) -> AnyPublisher<WeatherData, Error>
}

class WeatherService: WeatherSetting {
    var networkService: NetworkSettings
    init(networkService: NetworkSettings = NetworkService()) {
        self.networkService = networkService
    }
    func fetchData(by city: String) -> AnyPublisher<WeatherData, Error> {
        let endpoint = Endpoint.city(name: "q", value: city)
        print(endpoint.url)
        return networkService.fetchData(url: endpoint.url)
    }
}
