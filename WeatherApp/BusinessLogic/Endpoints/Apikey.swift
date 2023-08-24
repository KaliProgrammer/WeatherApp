//
//  Apikey.swift
//  WeatherApp
//
//  Created by MacBook Air on 19.08.2023.
//

import Foundation

struct Apikey {
     var apiKey: String {
      get {
        // 1
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
          fatalError("Couldn't find file 'Info.plist'.")
        }
        // 2
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API key") as? String else {
          fatalError("Couldn't find key 'API key' in 'Info.plist'.")
        }
        return value
      }
    }
}
