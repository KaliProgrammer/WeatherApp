//
//  MainViewModel.swift
//  WeatherApp
//
//  Created by MacBook Air on 19.08.2023.
//

import Foundation
import Combine

class MainViewModel {
    let weatherService: WeatherSetting = WeatherService()
    weak var appCoordinator: AppCoordinator!
    var cancellables = Set<AnyCancellable>()
    var weatherData = CurrentValueSubject<WeatherData, Error>(WeatherData(weather: [WeatherElement(id: 0,
                                                                                                   main: "",
                                                                                                   description: "",
                                                                                                   icon: "")],
                                                                          base: "",
                                                                          main: Main(temp: 0.0,
                                                                                     feelsLike: 0.0,
                                                                                     tempMin: 0.0,
                                                                                     tempMax: 0.0,
                                                                                     pressure: 0,
                                                                                     humidity: 0),
                                                                          visibility: 0,
                                                                          wind: Wind(speed: 0.0,
                                                                                     deg: 0),
                                                                          clouds: Clouds(all: 0),
                                                                          dt: 0,
                                                                          timezone: 0,
                                                                          id: 0,
                                                                          name: "",
                                                                          cod: 0))
    
    var temperaturePublisher = CurrentValueSubject<String, Never>("")
    var cityPublisher = CurrentValueSubject<String, Never>("")
    var descriptionPublisher = CurrentValueSubject<String, Never>("")
    var highTempPublisher = CurrentValueSubject<String, Never>("")
    var lowTempPublisher = CurrentValueSubject<String, Never>("")
    var feelsLikePublisher = CurrentValueSubject<String, Never>("")
    var feelsLikeViewPublisher = CurrentValueSubject<Int, Never>(0)
    var humidityPercentPublisher = CurrentValueSubject<String, Never>("")
    var humidityViewPublisher = CurrentValueSubject<Int, Never>(0)
    var weatherState = CurrentValueSubject<WeatherState, Never>(.background)
    
    var checkWeatherState: AnyPublisher<WeatherState, Never> {
        descriptionPublisher
            .map { state in
                if state.contains(WeatherStateConstants.wordcloud) || state.contains(WeatherStateConstants.wordCloud) {
                    return .cloudy
                } else if state.contains(WeatherStateConstants.wordstorm) || state.contains(WeatherStateConstants.wordStorm) {
                    return .storm
                } else if state.contains(WeatherStateConstants.wordClear) || state.contains(WeatherStateConstants.wordsun) || state.contains(WeatherStateConstants.wordSun) || state.contains(WeatherStateConstants.wordclear)  {
                    return .sunny
                } else if state.contains(WeatherStateConstants.wordrain) || state.contains(WeatherStateConstants.wordRain) || state.contains(WeatherStateConstants.wordDrizzle) {
                    return .rain
                } else if state.contains(WeatherStateConstants.wordmist) || state.contains(WeatherStateConstants.wordMist) || state.contains(WeatherStateConstants.wordhaze) || state.contains(WeatherStateConstants.wordHaze) {
                    return .mist
                }
                return .background
            }
            .eraseToAnyPublisher()
    }
    
    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
    }
    
    func getWeather(by city: String) {
        weatherService.fetchData(by: city)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] weatherData in
                self?.weatherData.value = weatherData
                self?.bindPublishers()
            }
            .store(in: &cancellables)
    }
    
    func bindPublishers() {
        temperaturePublisher.send(weatherData.value.convertedToCelcius)
        cityPublisher.send(weatherData.value.name ?? "")
        descriptionPublisher.send(weatherData.value.weather.first?.description?.capitalized ?? "")
        highTempPublisher.send(weatherData.value.main?.highTemp.uppercased() ?? "")
        lowTempPublisher.send(weatherData.value.main?.lowTemp.uppercased() ?? "")
        feelsLikePublisher.send(weatherData.value.main?.feelsLikeToString ?? "")
        feelsLikeViewPublisher.send(1)
        humidityPercentPublisher.send(weatherData.value.main?.humidityToString ?? "")
        humidityViewPublisher.send(1)
        checkWeatherState.sink { [weak self] state in
            self?.weatherState.send(state)
        }
        .store(in: &cancellables)
    }
    
    func sendEmptyData() {
        temperaturePublisher.send("")
        cityPublisher.send("")
        descriptionPublisher.send("")
        highTempPublisher.send("")
        lowTempPublisher.send("")
        feelsLikePublisher.send("")
        feelsLikeViewPublisher.send(0)
        humidityViewPublisher.send(0)
        humidityPercentPublisher.send("")
    }
}
