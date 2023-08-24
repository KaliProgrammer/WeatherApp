//
//  WeatherData.swift
//  WeatherApp
//
//  Created by MacBook Air on 19.08.2023.
//

import Foundation


// MARK: - Weather
struct WeatherData: Codable {
    let weather: [WeatherElement]
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
    
    var convertedToCelcius: String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 0
        let t = Measurement(value: main?.temp ?? 0.0, unit: UnitTemperature.kelvin)
        return formatter.string(from: t.converted(to: .celsius))
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
    
    //Computed property for data
    var feelsLikeToString: String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 0
        let t = Measurement(value: feelsLike, unit: UnitTemperature.kelvin)
        return formatter.string(from: t.converted(to: .celsius))
    }
    
    var humidityToString: String {
        "\(humidity) %"
    }
    
    var highTemp: String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 0
        let t = Measurement(value: tempMax, unit: UnitTemperature.kelvin)
        return "H: \(formatter.string(from: t.converted(to: .celsius)))"
    }
    
    var lowTemp: String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 0
        let t = Measurement(value: tempMin, unit: UnitTemperature.kelvin)
        return "L: \(formatter.string(from: t.converted(to: .celsius)))" 
    }

}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int
    let main, description, icon: String?

}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}


