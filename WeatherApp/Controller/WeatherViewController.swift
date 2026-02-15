//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Vinh Phan on 15/2/26.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
  
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var weatherImageView: UIImageView!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  
  let weatherService: WeatherService = WeatherService()
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    enableDismissKeyboardWhenTap()
    
    searchTextField.delegate = self
    
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
  }
  
  @IBAction func searchButtonPressed(_ sender: UIButton) {
    loadWeather(atCity: searchTextField.text ?? "")
  }
  
  @IBAction func currentLocationPressed(_ sender: UIButton) {
    locationManager.requestLocation()
  }
  
}

// MARK: UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    loadWeather(atCity: searchTextField.text ?? "")
    textField.resignFirstResponder()
    return true
  }
  
  func loadWeather(atCity cityName: String) {
    if cityName.isEmpty { return }
    
    searchTextField.text = ""
    
    Task {
      do {
        let weatherModel = try await weatherService.fetchWeather(cityName: cityName)
        await MainActor.run { 
          updateUI(weatherModel: weatherModel)
        }
      } catch {
        print("DEBUG - error: \(error.localizedDescription)")
      }
    }
  }
  
  func updateUI(weatherModel: WeatherModel) {
    weatherImageView.image = UIImage(
      systemName: weatherModel.weatherImageName
    )
    temperatureLabel.text = "\(Int(weatherModel.temperature))"
    cityLabel.text = weatherModel.cityName
  }
}

// MARK: CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    guard let location = locations.last else { return }
    
    Task {
      do {
        let weatherModel = try await weatherService.fetchWeather(
          lat: location.coordinate.latitude,
          lon: location.coordinate.longitude
        )
        await MainActor.run { 
          updateUI(weatherModel: weatherModel)
        }
      } catch {
        print("DEBUG - error: \(error.localizedDescription)")
      }
    }
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      manager.requestLocation()
    default:
      break
    }
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    print("DEBUG - error: \(error.localizedDescription)")
  }
}

extension UIViewController {
  func enableDismissKeyboardWhenTap() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tapGesture.cancelsTouchesInView = false
    view.addGestureRecognizer(tapGesture)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
