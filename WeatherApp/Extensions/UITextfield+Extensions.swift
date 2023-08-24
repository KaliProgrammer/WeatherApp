//
//  UITextfield+Extensions.swift
//  WeatherApp
//
//  Created by MacBook Air on 19.08.2023.
//

import Foundation
import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String?, Never> {
        NotificationCenter
            .default
            .publisher(for: UITextField.textDidChangeNotification,
                                             object: self)
            .map { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
}
