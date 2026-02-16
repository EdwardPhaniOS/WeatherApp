//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Vinh Phan on 16/2/26.
//

import SwiftUI

struct WeatherView: View {
  
  @ObservedObject private var viewModel: WeatherViewVM
  
  init(viewModel: WeatherViewVM) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    ZStack {
      backgroundView
      
      VStack(spacing: 8) {
        topViewContainer
        weatherInfoView
        Spacer()
      }
    }
    .ignoresSafeArea(.keyboard)
    .hideKeyboardOnTap()
    .onChange(of: viewModel.currentLocation) { _, newValue in
      Task {
        try await viewModel.loadWeatherByCurrentLocation()
      }
    }
    .task {
      viewModel.requestLocationPermission()
    }
  }
}

extension WeatherView {
  var topViewContainer: some View {
    HStack(spacing: 8) {
      Button(action: viewModel.requestCurrentLocation) {
        Image(systemName: "location.circle.fill")
          .foregroundColor(.primary)
          .font(.system(size: 25))
      }
      TextField("Enter City Name", text: $viewModel.query)
        .onSubmit {
          searchButtonPressed()
        }
        .submitLabel(.search)
        .multilineTextAlignment(.trailing)
        .padding(8)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(8)
      Button(action: searchButtonPressed) {
        Image(systemName: "magnifyingglass")
          .foregroundColor(.primary)
          .font(.system(size: 25))
      }
    }
    .padding(.horizontal)
    .padding(.top)
  }
  
  var weatherInfoView: some View {
    VStack(alignment: .trailing, spacing: 24) { 
      HStack {
        Spacer()
        Image(systemName: viewModel.weatherImageName)
          .font(.system(size: 80))
          .foregroundStyle(Color.accentColor)
      }
      HStack(spacing: 0) { 
        Text("\(viewModel.temperature)")
          .font(.system(size: 50).weight(.bold))
          .foregroundStyle(.primary)
          .multilineTextAlignment(.trailing)
        Text("℃")
          .font(.system(size: 50))
          .foregroundStyle(.primary)
          .multilineTextAlignment(.trailing)
      }
      Text(viewModel.cityName)
        .font(.system(size: 24))
        .foregroundStyle(.primary)
        .multilineTextAlignment(.trailing)
    }
    .padding(.horizontal)
  }
  
  var backgroundView: some View {
    Image("background")
        .resizable()
        .scaleEffect(2.5)
        .scaledToFit()
        .ignoresSafeArea()
  }
}

extension WeatherView {
  func searchButtonPressed() {
    Task {
      try await viewModel.loadWeatherByQuery()
      await MainActor.run { 
        hideKeyboard()
      }
    }
  }
}

extension View {
  func hideKeyboardOnTap() -> some View {
    self.onTapGesture {
      hideKeyboard()
    }
  }
  
  func hideKeyboard() {
    UIApplication.shared
      .sendAction(
        #selector(UIResponder.resignFirstResponder),
        to: nil,
        from: nil,
        for: nil
      )
  }
}

#Preview {
  WeatherView(viewModel: WeatherViewVM())
}
