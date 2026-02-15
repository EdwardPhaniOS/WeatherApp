//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Vinh Phan on 15/2/26.
//

import Foundation

struct WeatherData: Decodable {
  let weather: [Weather]
  let main: Main
  let name: String
}

struct Weather: Decodable {
  let id: Int
  let description: String
}

struct Main: Decodable {
  let temp: Float
}
