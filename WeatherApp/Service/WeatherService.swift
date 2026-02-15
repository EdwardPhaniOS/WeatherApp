//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Vinh Phan on 15/2/26.
//

import Foundation

struct WeatherService {
  
  let apiClient: APIClient
  
  init(apiClient: APIClient = URLSessionAPIClient()) {
    self.apiClient = apiClient
  }
  
  func fetchWeather(cityName: String) async throws -> WeatherModel {
    let url = WeatherEndpoint
      .currentWeatherByCity(city: cityName)
      .url()
    let weatherData: WeatherData = try await apiClient.get(url: url)
    return WeatherModelMapper.toWeatherModel(from: weatherData)
  }
  
  func fetchWeather(lat: Double, lon: Double) async throws -> WeatherModel {
    let url = WeatherEndpoint
      .currentWeatherByCoordinates(lat: lat, lon: lon)
      .url()
    let weatherData: WeatherData = try await apiClient.get(url: url)
    return WeatherModelMapper.toWeatherModel(from: weatherData)
  }
}
