//
//  ViewController.swift
//  WeatherApp
//
//  Created by MacBook Air on 19.08.2023.
//

import UIKit
import Combine
import SnapKit

class MainViewController: UIViewController {
    
    var cancellables = Set<AnyCancellable>()
    var viewModel: MainViewModel? = nil
    
    private lazy var backgroundView: UIView = {
        let backgroundImage = UIView()
        return backgroundImage
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: WeatherConstants.backgroundName)
        return backgroundImage
    }()
    
    private lazy var customTextField: UITextField = {
        let customTextField = UITextField()
        customTextField.borderStyle = .roundedRect
        customTextField.backgroundColor = .secondarySystemBackground
        customTextField.layer.cornerRadius = WeatherConstants.textFieldCornerRadius
        customTextField.placeholder = WeatherConstants.placeholder
        customTextField.layer.masksToBounds = true
        customTextField.clipsToBounds = true
        return customTextField
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: WeatherConstants.cityLabelFontSize)
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: WeatherConstants.tempLabelFontSize)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: WeatherConstants.descriptionAndHighLowLabelFontSize, weight: .bold)
        return label
    }()
    
    private lazy var hightTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: WeatherConstants.descriptionAndHighLowLabelFontSize, weight: .bold)
        return label
    }()
    
    private lazy var lowTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: WeatherConstants.descriptionAndHighLowLabelFontSize, weight: .bold)
        return label
    }()
    
    //feelsLikeView
    private lazy var feelsLikeView: UIView = {
        let customView = UIView()
        customView.layer.masksToBounds = true
        customView.layer.cornerRadius = WeatherConstants.viewCornerRadius
        customView.backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(WeatherConstants.alphaComponent)
        return customView
    }()
    
    private lazy var feelsLikeImage: UIImageView = {
        let feelsLikeImage = UIImageView()
        feelsLikeImage.layer.masksToBounds = true
        feelsLikeImage.clipsToBounds = true
        feelsLikeImage.image = UIImage(systemName: WeatherConstants.feelsLikeImageName)
        return feelsLikeImage
    }()
    
    private lazy var feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.text = WeatherConstants.feelsLikeLabel
        label.font = .systemFont(ofSize: WeatherConstants.feelsLikeAndHumidityLabelFontSize)
        return label
    }()
    
    private lazy var tempFeelsLikeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: WeatherConstants.tempfeelsLikeAndHumidityLabelFontSize, weight: .medium)
        return label
    }()
    
    //humidityView
    private lazy var humidityView: UIView = {
        let customView = UIView()
        customView.backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(WeatherConstants.alphaComponent)
        customView.layer.masksToBounds = true
        customView.layer.cornerRadius = WeatherConstants.viewCornerRadius
        return customView
    }()
    
    private lazy var humidityImage: UIImageView = {
        let feelsLikeImage = UIImageView()
        feelsLikeImage.layer.masksToBounds = true
        feelsLikeImage.clipsToBounds = true
        feelsLikeImage.image = UIImage(systemName: WeatherConstants.humidityImageName)
        return feelsLikeImage
    }()
    
    private lazy var humidityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.text = WeatherConstants.humidityLabel
        label.font = .systemFont(ofSize: WeatherConstants.feelsLikeAndHumidityLabelFontSize)
        return label
    }()
    
    private lazy var humidityPercentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: WeatherConstants.tempfeelsLikeAndHumidityLabelFontSize, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextfieldPublisher()
        setupBindingsForBasicInfo()
        setupBindingsForHighAndLowTemp()
        setupBindingForHumidity()
        setupBindingForFeelsLikeView()
        bindBackgroundImageValue()
    }
    
    private func setupBindingsForBasicInfo() {
        if let temperature = viewModel?.temperaturePublisher,
           let cityName = viewModel?.cityPublisher,
           let description = viewModel?.descriptionPublisher {
            
            Publishers.CombineLatest3(temperature, cityName, description)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] (temp, city, descr) in
                    self?.temperatureLabel.text = temp
                    self?.cityLabel.text = city
                    self?.descriptionLabel.text = descr
                }
                .store(in: &cancellables)
        }
    }
    
    private func setupBindingsForHighAndLowTemp() {
        if let highTemp = viewModel?.highTempPublisher,
           let lowTemp = viewModel?.lowTempPublisher {
            Publishers.CombineLatest(highTemp, lowTemp)
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] (hightTemperature, lowTemperature) in
                    self?.hightTempLabel.text = hightTemperature
                    self?.lowTempLabel.text = lowTemperature
                })
                .store(in: &cancellables)
        }
    }
    
    private func setupBindingForFeelsLikeView() {
        if let visibility = viewModel?.feelsLikeViewPublisher,
           let tempText = viewModel?.feelsLikePublisher {
            Publishers.CombineLatest(visibility, tempText)
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] (visibility, text) in
                    self?.feelsLikeView.alpha = CGFloat(visibility)
                    self?.tempFeelsLikeLabel.text = text
                })
                .store(in: &cancellables)
        }
    }
    
    private func setupBindingForHumidity() {
        if let visibility = viewModel?.humidityViewPublisher,
           let humidityText = viewModel?.humidityPercentPublisher {
            Publishers.CombineLatest(visibility, humidityText)
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] (visibility, text) in
                    self?.humidityView.alpha = CGFloat(visibility)
                    self?.humidityPercentLabel.text = text
                })
                .store(in: &cancellables)
        }
    }
    
    private func bindBackgroundImageValue() {
        if let image = viewModel?.weatherState {
            image
                .receive(on: DispatchQueue.main)
                .sink { [weak self] state in
                    switch state {
                    case .cloudy:
                        return (self?.backgroundImage.image = UIImage(named: WeatherStateConstants.cloudy))!
                    case .storm:
                        return (self?.backgroundImage.image = UIImage(named: WeatherStateConstants.storm))!
                    case .sunny:
                        return (self?.backgroundImage.image = UIImage(named: WeatherStateConstants.sunny))!
                    case .rain:
                        return (self?.backgroundImage.image = UIImage(named: WeatherStateConstants.rain))!
                    case .background:
                        return (self?.backgroundImage.image = UIImage(named: WeatherStateConstants.background))!
                    case .mist:
                        return (self?.backgroundImage.image = UIImage(named: WeatherStateConstants.mist))!
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    private func setupTextfieldPublisher() {
        customTextField.textPublisher
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] newValue in
                
                self?.viewModel?.sendEmptyData()
                self?.viewModel?.getWeather(by: newValue ?? "")
            }
            .store(in: &cancellables)
    }
    
    
    private func setupUI() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(backgroundImage)
        
        backgroundView.addSubviews([
            customTextField,
            temperatureLabel,
            cityLabel,
            descriptionLabel,
            feelsLikeView,
            humidityView,
            hightTempLabel,
            lowTempLabel
        ])
        
        feelsLikeView.addSubviews([
            feelsLikeImage,
            feelsLikeLabel,
            tempFeelsLikeLabel
        ])
        
        humidityView.addSubviews([
            humidityImage,
            humidityLabel,
            humidityPercentLabel
        ])
        
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        backgroundImage.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        customTextField.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.top).offset(WeatherConstants.textFieldTop)
            make.leading.equalTo(backgroundView.snp.leading).offset(WeatherConstants.leadingTrailing)
            make.trailing.equalTo(backgroundView.snp.trailing).offset(-WeatherConstants.leadingTrailing)
            make.height.equalTo(WeatherConstants.height)
        }
        
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(customTextField.snp.bottom).offset(WeatherConstants.cityTop)
            make.centerX.equalTo(backgroundView.snp.centerX)
            make.width.equalTo(WeatherConstants.cityAndDescriptionLabelWidth)
            make.height.equalTo(WeatherConstants.height)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom)
            make.centerX.equalTo(backgroundView.snp.centerX)
            make.width.equalTo(WeatherConstants.tempLabelWidth)
            make.height.equalTo(WeatherConstants.height)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom)
            make.centerX.equalTo(backgroundView.snp.centerX)
            make.width.equalTo(WeatherConstants.cityAndDescriptionLabelWidth)
            make.height.equalTo(WeatherConstants.height)
        }
        
        //high temp
        hightTempLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.leading.equalTo(backgroundView.snp.leading).offset(WeatherConstants.hightTempLabelLeading)
            make.width.equalTo(WeatherConstants.tempLabelWidth)
            make.height.equalTo(WeatherConstants.heightForTempLabel)
        }
        
        //low temp
        lowTempLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.leading.equalTo(hightTempLabel.snp.trailing).offset(WeatherConstants.lowTempLabelLeading)
            make.width.equalTo(WeatherConstants.tempLabelWidth)
            make.height.equalTo(WeatherConstants.heightForTempLabel)
        }
        
        feelsLikeView.snp.makeConstraints { make in
            make.leading.equalTo(backgroundView.snp.leading).offset(WeatherConstants.leadingTrailing)
            make.top.equalTo(hightTempLabel.snp.bottom).offset(WeatherConstants.viewTop)
            make.height.width.equalTo(WeatherConstants.viewSize)
        }
        
        feelsLikeImage.snp.makeConstraints { make in
            make.leading.equalTo(feelsLikeView.snp.leading).offset(WeatherConstants.leadingTrailing)
            make.top.equalTo(feelsLikeView.snp.top).offset(WeatherConstants.feelsLikeImageAndLabelTop)
            make.trailing.equalTo(feelsLikeLabel.snp.leading).offset(-WeatherConstants.feelsLikeLeadingTrailing)
            make.height.equalTo(WeatherConstants.imageLabelHeight)
        }
        
        feelsLikeLabel.snp.makeConstraints { make in
            make.leading.equalTo(feelsLikeImage.snp.trailing).offset(WeatherConstants.feelsLikeLeadingTrailing)
            make.top.equalTo(feelsLikeView.snp.top).offset(WeatherConstants.feelsLikeImageAndLabelTop)
            make.height.equalTo(WeatherConstants.imageLabelHeight)
            make.width.equalTo(WeatherConstants.feelsLikeWidth)
        }
        
        tempFeelsLikeLabel.snp.makeConstraints { make in
            make.leading.equalTo(feelsLikeView.snp.leading).offset(WeatherConstants.leadingTrailing)
            make.top.equalTo(feelsLikeLabel.snp.bottom).offset(WeatherConstants.tempFeelsLikeLabelTop)
            make.height.equalTo(WeatherConstants.tempFeelsLikeLabelHeight)
            make.width.equalTo(WeatherConstants.feelsLikeWidth)
        }
        
        //humidityView
        humidityView.snp.makeConstraints { make in
            make.trailing.equalTo(backgroundView.snp.trailing).offset(-WeatherConstants.leadingTrailing)
            make.top.equalTo(hightTempLabel.snp.bottom).offset(WeatherConstants.viewTop)
            make.height.width.equalTo(WeatherConstants.viewSize)
        }
        
        humidityImage.snp.makeConstraints { make in
            make.leading.equalTo(humidityView.snp.leading).offset(WeatherConstants.leadingTrailing)
            make.top.equalTo(humidityView.snp.top).offset(WeatherConstants.humidityTop)
            make.trailing.equalTo(humidityLabel.snp.leading).offset(-WeatherConstants.humidityLeadingTrailing)
            make.height.equalTo(WeatherConstants.imageLabelHeight)
        }
        
        humidityLabel.snp.makeConstraints { make in
            make.leading.equalTo(humidityImage.snp.trailing).offset(WeatherConstants.humidityLeadingTrailing)
            make.top.equalTo(humidityView.snp.top).offset(WeatherConstants.humidityTop)
            make.height.equalTo(WeatherConstants.imageLabelHeight)
            make.width.equalTo(WeatherConstants.humidityWidth)
        }
        
        humidityPercentLabel.snp.makeConstraints { make in
            make.leading.equalTo(humidityView.snp.leading).offset(WeatherConstants.leadingTrailing)
            make.top.equalTo(humidityLabel.snp.bottom).offset(WeatherConstants.humidityTop)
            make.height.equalTo(WeatherConstants.humidityPercentLabelHeight)
            make.width.equalTo(WeatherConstants.humidityWidth)
        }
    }
}

