//
//  DetailView.swift
//  veepee weather app
//
//  Created by Joel Sene on 23/06/2024.
//

import SwiftUI

struct ForecastDetailView: View {
    @StateObject var viewModel: DetailViewModel
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("background-light")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .center) {
                        Text("\(String(format: "%.0f°C", viewModel.detailItem.temp))")
                            .font(.largeTitle)
                            .fontWeight(.medium)
                            .foregroundStyle(viewModel.detailItem.temp == viewModel.detailItem.maxTemp ? .red : .blue)
                        Text("(\(String(format: "%.0f°C", viewModel.detailItem.feelsLike)))")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundStyle(viewModel.detailItem.temp == viewModel.detailItem.maxTemp ? .red : .blue)
                            .padding(.top, -8)
                        HStack {
                            Text("Min: \(String(format: "%.0f°C", viewModel.detailItem.minTemp))")
                                .font(.caption)
                                .foregroundStyle(.blue)
                            Spacer()
                            Text("Max: \(String(format: "%.0f°C", viewModel.detailItem.maxTemp))")
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                        .frame(height: 80)
                        .padding(.leading, 36)
                        .padding(.trailing, 36)
                    }
                    .background(Color.cyan.opacity(0.1))
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    .frame(width: geometry.size.width - 16)
                    Divider()
                        .padding(.trailing, 16)
                    HStack(alignment: .center) {
                        Text("Humidity: \(String(describing: viewModel.detailItem.humidity))%")
                            .font(.subheadline)
                            .foregroundStyle(.black)
                            .padding(.top, 8)
                            .padding(.bottom, 8)
                        Spacer()
                        Text("Wind speed: \(String(format: "%.1fKm/h", viewModel.detailItem.windSpeed))")
                            .font(.subheadline)
                            .padding(.trailing, 16)
                            .foregroundStyle(.black)
                    }
                    Divider()
                        .padding(.trailing, 16)
                    VStack(alignment: .leading) {
                        Text("Hourly Forecasts")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .padding(.bottom, 4)
                        CarouselView(hourlyForecasts: viewModel.detailItem.hourlyForecast)
                            .frame(height: 100)
                    }
                    
                    Spacer()
                    Divider()
                }
                .padding()
                .navigationTitle(viewModel.detailItem.cityName)
            }
        }
    }
}
