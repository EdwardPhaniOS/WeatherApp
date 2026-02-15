//
//  WeatherEndpoint.swift
//  WeatherApp
//
//  Created by Vinh Phan on 15/2/26.
//

import Foundation

enum WeatherEndpoint {
  case currentWeatherByCity(city: String)
  case currentWeatherByCoordinates(lat: Double, lon: Double)
  
  private var path: String {
    switch self {
    case .currentWeatherByCity:
      return "/weather"
    case .currentWeatherByCoordinates:
      return "/weather"
    }
  }
  
  private var queryItems: [URLQueryItem] {
    var items: [URLQueryItem] = [
      URLQueryItem(name: "units", value: "metric")
    ]
    
    switch self {
    case .currentWeatherByCity(let city):
      items.append(URLQueryItem(name: "q", value: city))
    case .currentWeatherByCoordinates(let lat, let lon):
      items.append(URLQueryItem(name: "lat", value: "\(lat)"))
      items.append(URLQueryItem(name: "lon", value: "\(lon)"))
    }
    
    return items
  }
  
  func url(withBaseURL baseURL: URL = AppConfig.shared.baseURL, 
           apiKey: String = AppConfig.shared.apiKey) -> URL {
    var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
    let basePath = baseURL.path == "/" ? "" : baseURL.path
    components.path = basePath.appending(path)
    
    var queryItems = queryItems
    queryItems.append(URLQueryItem(name: "appid", value: apiKey))
    components.queryItems = queryItems
    
    return components.url!
  }
}
