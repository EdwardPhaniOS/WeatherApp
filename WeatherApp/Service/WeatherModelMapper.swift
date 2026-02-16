//
//  WeatherModelMapper.swift
//  WeatherApp
//
//  Created by Vinh Phan on 15/2/26.
//

import Foundation

struct WeatherModelMapper {
  static func toWeatherModel(from weatherData: WeatherData) -> WeatherModel {
    let imageName = getImageName(conditionId: weatherData.weather.first!.id)
    let model = WeatherModel(
      weatherImageName: imageName,
      temperature: weatherData.main.temp,
      cityName: weatherData.name
    )
    
    return model
  }
  
  private static func getImageName(conditionId: Int) -> String {
    switch conditionId {
    case 200...232:
      return "cloud.bolt"
    case 300...321:
      return "cloud.drizzle"
    case 500...531:
      return "cloud.rain"
    case 600...622:
      return "cloud.snow"
    case 701...781:
      return "cloud.fog"
    case 800:
      return "sun.max"
    case 801...804:
      return "cloud.bolt"
    default:
      return "cloud"
    }
  }
}
