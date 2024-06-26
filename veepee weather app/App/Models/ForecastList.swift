import Foundation

// MARK: - Forecast
struct Forecast: Codable, Hashable {
    let cod: String
    let message, cnt: Int
    let list: [ForecastList]
    let city: City
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(cod)
        hasher.combine(message)
        hasher.combine(cnt)
        hasher.combine(list)
        hasher.combine(city)
    }
    
    static func == (lhs: Forecast, rhs: Forecast) -> Bool {
        return lhs.cod == rhs.cod && lhs.message == rhs.message && lhs.cnt == rhs.cnt && lhs.list == rhs.list && lhs.city == rhs.city
    }
}

// MARK: - City
struct City: Codable, Hashable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(coord)
        hasher.combine(country)
        hasher.combine(population)
        hasher.combine(timezone)
        hasher.combine(sunrise)
        hasher.combine(sunset)
    }
}

// MARK: - Coord
struct Coord: Codable, Hashable {
    let lat, lon: Double
}

// MARK: - List
struct ForecastList: Codable, Hashable {
    let dt: Int
    let main: MainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let sys: Sys
    let dtTxt: String
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case rain
    }
    
    var date: String {
        return String(dtTxt.prefix(10))
    }
    
    enum DateFormatStyle {
        case full
        case day
        case hour
    }
    
    func formattedDate(format: DateFormatStyle) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: dtTxt) else { return dtTxt }
        
        switch format {
        case .full:
            formatter.dateFormat = "E. dd MMM"
        case .day:
            formatter.dateFormat = "dd"
        case .hour:
            formatter.dateFormat = "HH"
        }
        return formatter.string(from: date)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(dt)
        hasher.combine(main)
        hasher.combine(weather)
        hasher.combine(clouds)
        hasher.combine(wind)
        hasher.combine(visibility)
        hasher.combine(pop)
        hasher.combine(sys)
        hasher.combine(dtTxt)
        hasher.combine(rain)
    }
    
    static func == (lhs: ForecastList, rhs: ForecastList) -> Bool {
        return lhs.dt == rhs.dt && lhs.main == rhs.main && lhs.weather == rhs.weather && lhs.clouds == rhs.clouds && lhs.wind == rhs.wind && lhs.visibility == rhs.visibility && lhs.pop == rhs.pop && lhs.sys == rhs.sys && lhs.dtTxt == rhs.dtTxt && lhs.rain == rhs.rain
    }
}

// MARK: - Clouds
struct Clouds: Codable, Hashable {
    let all: Int
}

// MARK: - MainClass
struct MainClass: Codable, Hashable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable, Hashable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct Sys: Codable, Hashable {
    let pod: Pod
}

enum Pod: String, Codable, Hashable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct Weather: Codable, Hashable {
    let id: Int
    let main: MainEnum
    let description, icon: String
    
    var iconURL: String {
        return "https://openweathermap.org/img/wn/\(icon)@2x.png"
    }
}

enum MainEnum: String, Codable, Hashable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

// MARK: - Wind
struct Wind: Codable, Hashable {
    let speed: Double
    let deg: Int
    let gust: Double
}
