//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by MacBook Air on 19.08.2023.
//

import Foundation
import UIKit

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}


class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navCoordinator: UINavigationController) {
        self.navigationController = navCoordinator
    }
    
    func start() {
        goToMainVC()
    }
    
    func goToMainVC() {
        let mainViewController = MainViewController()
        let mainViewModel = MainViewModel(appCoordinator: self)
        mainViewController.viewModel = mainViewModel
        navigationController.pushViewController(mainViewController, animated: true)
    }
}
