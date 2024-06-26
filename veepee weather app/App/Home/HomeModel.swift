import Foundation

struct HomeModel: Identifiable {
    let id = UUID()
    let cityName: String
    let date: String
    let fullDate: String
    let weatherDescription: String
    let temp: Double
    let minTemp: Double
    let maxTemp: Double
    let hourlyForecast: [ForecastList]
    let humidity: Int
    let windSpeed: Double
    let feelsLike: Double
    let iconURL: String
    
}
