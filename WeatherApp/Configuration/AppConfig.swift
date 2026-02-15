//
//  AppConfig.swift
//  WeatherApp
//
//  Created by Vinh Phan on 15/2/26.
//

import Foundation

enum Enviroment {
  case development
  case production
}

class AppConfig {
  static let shared: AppConfig = AppConfig()
  
  private(set) var enviroment: Enviroment
  private(set) var apiKey: String
  private(set) var baseURL: URL
  
  var defaultHeaders: [String: String] {
    return [
      "Accept" : "application/json",
      "Content-Type" : "application/json"
    ]
  }
  
  var urlSessionConfiguration: URLSessionConfiguration {
    let config = URLSessionConfiguration.default
    config.httpAdditionalHeaders = defaultHeaders
    config.timeoutIntervalForRequest = requestTimeout
    return config
  }
  
  private var requestTimeout: TimeInterval = 60
  
  init() {
#if DEBUG
    enviroment = .development
#else
    enviroment = .production
#endif
    
    var baseURLString: String
    
    switch enviroment {
    case .development:
      baseURLString = "https://api.openweathermap.org/data/2.5"
      apiKey = Bundle.main.object(forInfoDictionaryKey: "DEV_API_KEY") as? String ?? ""
    case .production:
      baseURLString = "https://api.openweathermap.org/data/2.5"
      apiKey = Bundle.main.object(forInfoDictionaryKey: "PROD_API_KEY") as? String ?? ""
    }
    
    baseURL = URL(string: baseURLString)!
  }
  
  func updateAPIKey(_ key: String) {
    apiKey = key
  }
}
