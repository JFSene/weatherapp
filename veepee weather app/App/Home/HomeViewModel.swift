import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var response: Forecast?
    @Published var dailyForecasts: [ForecastList]?
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchForecast() {
        isLoading = true
        errorMessage = nil
        
        // Example usage of fetchTransactions
        let parameters = NetworkService.EndpointParameters(
            q: "Paris,FR",
            units: "metric"
        )
        
        NetworkService.shared.fetchTransactions(parameters: parameters)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleFetchError(error) // Handle error if fetch fails
                }
            }, receiveValue: { [weak self] forecast in
                self?.dailyForecasts = self?.filterDailyForecasts(forecast) ?? []
                self?.response = forecast
            })
            .store(in: &cancellables)
    }
    
    private func filterDailyForecasts(_ forecasts: Forecast) -> [ForecastList] {
        var seenDates = Set<String>()
        return forecasts.list.filter { list in
            let date = list.date
            guard !seenDates.contains(date) else { return false }
            seenDates.insert(date)
            return true
        }
    }
    
    func getHourlyForecasts(for date: String) -> [ForecastList] {
        guard let forecasts = response?.list else { return [] }
        let hourlyForecasts = forecasts.filter { $0.date == date }
        return hourlyForecasts.sorted(by: { $0.dt < $1.dt })
    }
    
    // Computed property to return an array of HomeModel
       var dailyTemperatureExtremes: [HomeModel] {
           guard let forecasts = dailyForecasts, let cityName = response?.city.name else { return [] }
           
           return forecasts.compactMap { forecast in
               let hourlyForecasts = getHourlyForecasts(for: forecast.date)
               let minTemp = hourlyForecasts.min(by: { $0.main.tempMin < $1.main.tempMin })?.main.tempMin ?? forecast.main.tempMin
               let maxTemp = hourlyForecasts.max(by: { $0.main.tempMax < $1.main.tempMax })?.main.tempMax ?? forecast.main.tempMax
               let iconURL = forecast.weather.first?.iconURL ?? ""
               print(iconURL)
               
               return HomeModel(
                   cityName: cityName,
                   date: forecast.formattedDate(format: .full),
                   fullDate: forecast.dtTxt,
                   weatherDescription: forecast.weather.first?.description ?? "",
                   temp: forecast.main.temp,
                   minTemp: minTemp,
                   maxTemp: maxTemp,
                   hourlyForecast: hourlyForecasts, 
                   humidity: forecast.main.humidity, 
                   windSpeed: forecast.wind.speed, 
                   feelsLike: forecast.main.feelsLike, 
                   iconURL: iconURL
               )
           }
       }
    
    private func handleFetchError(_ error: Error) {
        // Check if the error is a URLError
        if let urlError = error as? URLError {
            // Handle specific URLError cases
            switch urlError.code {
            case .badURL:
                self.errorMessage = "Invalid URL. Please check the URL and try again."
            case .timedOut:
                self.errorMessage = "The request timed out. Please try again."
            case .cannotFindHost:
                self.errorMessage = "Cannot find the host. Please check your internet connection."
            case .cannotConnectToHost:
                self.errorMessage = "Cannot connect to the host. Please check your internet connection."
            case .networkConnectionLost:
                self.errorMessage = "The network connection was lost. Please try again."
            case .notConnectedToInternet:
                self.errorMessage = "You are not connected to the internet. Please check your connection."
            default:
                self.errorMessage = "An unexpected error occurred. Please try again. (Error code: \(urlError.code.rawValue))"
            }
        } else {
            // Default error message for unexpected errors
            self.errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }
        
        // Debugging information for error
        print("Error: \(error.localizedDescription)")
        print("Error Details: \(error)")
        
        // Display alert to user
        self.showAlert = true
        // Stop loading indicator
        self.isLoading = false
    }
    
}
