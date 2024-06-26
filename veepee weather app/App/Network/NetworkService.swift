import Foundation
import Combine

// Define a final class NetworkService for managing network requests
final class NetworkService {
    // Create a shared singleton instance of NetworkService
    static let shared = NetworkService()
    // Define the base URL for the API
    private let baseURL = "https://api.openweathermap.org/data/2.5/"
    // API Key
    private let apiKey = "027a931ad61bda7ad9245b12459771a6"
    
    // Private initializer to ensure the singleton pattern
    private init() {}

    // Struct to hold the endpoint parameters
    struct EndpointParameters {
        let q: String
        let units: String
        
        func toQueryString() -> String {
            return "q=\(q)&units=\(units)&appid=\(NetworkService.shared.apiKey)"
        }
    }
    
    // Private method to create and send a network request
    private func makeRequest(endpoint: String, method: String, body: [String: Any]? = nil) -> AnyPublisher<Data, Error> {
        // Ensure the URL is valid, otherwise return a failure publisher
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url) // Create a URL request with the URL
        request.httpMethod = method // Set the HTTP method (GET, POST, etc.)
        
        // If there's a body, serialize it to JSON and set the appropriate headers
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                return Fail(error: error).eraseToAnyPublisher() // Return a failure publisher if serialization fails
            }
        }
        
        // Use URLSession to perform the network request and handle the response
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                // Ensure the response is an HTTP response and check the status code
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                // Debugging information for response
                print("URL: \(url)")
                print("Status Code: \(httpResponse.statusCode)")
                print("Response Headers: \(httpResponse.allHeaderFields)")
                
                // Check for valid status code
                guard 200..<300 ~= httpResponse.statusCode else {
                    throw URLError(URLError.Code(rawValue: httpResponse.statusCode))
                }
                
                return data // Return the data if the response is valid
            }
            .eraseToAnyPublisher()
    }

    // Public method to fetch transactions, returning a publisher of an array of TransactionsModel
    func fetchTransactions(parameters: EndpointParameters) -> AnyPublisher<Forecast, Error> {
        let endpoint = "forecast?\(parameters.toQueryString())"
        return makeRequest(endpoint: endpoint, method: "GET")
            .decode(type: Forecast.self, decoder: JSONDecoder()) // Decode the JSON response into an array of TransactionsModel
            .catch { error -> AnyPublisher<Forecast, Error> in
                // Debugging information for errors
                print("Error: \(error.localizedDescription)")
                print("Error Details: \(error)")
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
