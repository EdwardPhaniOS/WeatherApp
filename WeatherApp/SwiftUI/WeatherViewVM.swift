//
//  WeatherViewVM.swift
//  WeatherApp
//
//  Created by Vinh Phan on 16/2/26.
//

import Foundation
import CoreLocation

class WeatherViewVM: NSObject, ObservableObject {
  @Published var query: String = ""
  @Published var cityName: String = ""
  @Published var temperature: Int = 0
  @Published var weatherImageName: String = "cloud"
  @Published var currentLocation: CLLocation?
  
  private var weatherService: WeatherService
  private var locationManager: CLLocationManager
  
  init(weatherService: WeatherService = WeatherService(),
       locationManager: CLLocationManager = CLLocationManager()
  ) {
    self.weatherService = weatherService
    self.locationManager = locationManager
    super.init()
    
    self.locationManager.delegate = self
  }
  
  func requestLocationPermission() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  func requestCurrentLocation() {
    locationManager.requestLocation()
  }
  
  func loadWeatherByQuery() async throws {
    let cityName = query
    if cityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      return
    }
    
    await MainActor.run { 
      query = ""
    }
    
    let weatherModel = try await weatherService.fetchWeather(cityName: cityName)
    await updateUI(weatherModel: weatherModel)
  }
  
  func loadWeatherByCurrentLocation() async throws {
    guard let location = currentLocation else { return }
    
    let weatherModel = try await weatherService.fetchWeather(
      lat: location.coordinate.latitude,
      lon: location.coordinate.longitude
    )
    await updateUI(weatherModel: weatherModel)
  }
  
  func updateUI(weatherModel: WeatherModel) async {
    await MainActor.run { 
      query = ""
      temperature = Int(weatherModel.temperature)
      cityName = weatherModel.cityName
      weatherImageName = weatherModel.weatherImageName
    }
  }
  
}

// MARK: CLLocationManagerDelegate
extension WeatherViewVM: CLLocationManagerDelegate {
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      requestCurrentLocation()
    default:
      break
    }
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    guard let location = locations.last else { return }
    
    DispatchQueue.main.async {
      self.currentLocation = location
    }
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: any Error
  ) {
    print("DEBUG - error \(error)")
  }
}
