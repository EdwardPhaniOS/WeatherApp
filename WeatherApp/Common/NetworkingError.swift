//
//  NetworkingError.swift
//  WeatherApp
//
//  Created by Vinh Phan on 16/2/26.
//

import Foundation

enum NetworkingError: Error, LocalizedError {
  case invalidResponse
  case clientError(statusCode: Int)
  case serverError(statusCode: Int)
  case decodingError(error: Error)
  case noData
  case unexpectedStatusCode(statusCode: Int)

  var errorDescription: String? {
    switch self {
    case .invalidResponse:
      return "Invalid Response"
    case .clientError(let code):
      return "Client error (\(code))."
    case .serverError(let code):
      return "Server error (\(code))."
    case .decodingError(let error):
      return "Decoding failed: \(error.localizedDescription)"
    case .noData:
      return "No data received"
    case .unexpectedStatusCode(let code):
      return "Unexpected HTTP status code: \(code)."
    }
  }
}
