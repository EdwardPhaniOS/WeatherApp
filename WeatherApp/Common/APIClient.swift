//
//  APIClient.swift
//  WeatherApp
//
//  Created by Vinh Phan on 15/2/26.
//

import Foundation

protocol APIClient {
  func get<T: Decodable>(url: URL) async throws -> T
}
