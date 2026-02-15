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

enum NetworkingError: Error, LocalizedError {
  case invalidURL
  case badRequest
  case serverError
  case decodingError
}

class URLSessionAPIClient: APIClient {
  
  let urlSessionConfig: URLSessionConfiguration
  
  init(urlSessionConfig: URLSessionConfiguration = AppConfig.shared.urlSessionConfiguration) {
    self.urlSessionConfig = urlSessionConfig
  }
  
  func get<T: Decodable>(url: URL) async throws -> T {
    let request = URLRequest(url: url)
    
    let (data, response) = try await URLSession(configuration: urlSessionConfig).data(
      for: request
    )
    
    if let httpResponse = response as? HTTPURLResponse {
      let statusCode = httpResponse.statusCode
      
      switch statusCode {
      case 400...499:
        throw NetworkingError.badRequest
      case 500...599:
        throw NetworkingError.serverError
      default:
        break
      }
    }
    
    do {
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      throw NetworkingError.decodingError
    }
  }
}
