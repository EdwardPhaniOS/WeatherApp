//
//  URLSessionAPIClient.swift
//  WeatherApp
//
//  Created by Vinh Phan on 16/2/26.
//

import Foundation

class URLSessionAPIClient: APIClient {
  
  let urlSessionConfig: URLSessionConfiguration
  
  init(urlSessionConfig: URLSessionConfiguration = AppConfig.shared.urlSessionConfiguration) {
    self.urlSessionConfig = urlSessionConfig
  }
  
  func get<T: Decodable>(url: URL) async throws -> T {
    let request = URLRequest(url: url)
    
    let (data, response) = try await URLSession(configuration: urlSessionConfig).data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkingError.invalidResponse
    }
    
    let statusCode = httpResponse.statusCode
    
    switch statusCode {
    case 200...299:
      guard !data.isEmpty else {
        throw NetworkingError.noData
      }
      
      do {
        return try JSONDecoder().decode(T.self, from: data)
      } catch {
        throw NetworkingError.decodingError(error: error)
      }
    case 400...499:
      throw NetworkingError.clientError(statusCode: statusCode)
    case 500...599:
      throw NetworkingError.serverError(statusCode: statusCode)
    default:
      throw NetworkingError.unexpectedStatusCode(statusCode: statusCode)
    }
  }
}
