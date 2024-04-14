//
//  WeatherAPI.swift
//  Weather
//
//  Created by Donald Riedl on 11/11/23.
//

import Foundation

struct WeatherAPI {
    private static let baseURLString = "https://api.openweathermap.org/data/2.5/"
    private static let iconBaseURLString = "https://openweathermap.org/img/w/"
    private static let apiKey = "349010f1d6e0ff61e58077d47f11c2ed"
    enum EndPoint: String {
        case currentWeather = "weather"
        case weatherForecast = "forecast"
    }
    
    static func currentWeatherURL(lat: Double, lon: Double) -> URL {
        return URL(string: "\(baseURLString)\(EndPoint.currentWeather.rawValue)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=imperial")!
    }
    
    static func weatherForecastURL(lat: Double, lon: Double) -> URL {
        return URL(string: "\(baseURLString)\(EndPoint.weatherForecast.rawValue)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=imperial")!
    }
    
    static func iconURL(icon: String) -> URL {
        return URL(string: "\(iconBaseURLString)\(icon).png")!
    }
    
    struct CurrentWeatherResponse: Codable {
        let weather: [WeatherDetails]
        let main: WeatherMain
        let wind: WeatherWind
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case weather = "weather"
            case main = "main"
            case wind = "wind"
            case name = "name"
        }
    }
    
    struct WeatherForecastResponse: Codable {
        let list: [WeatherForecast]
        
        enum CodingKeys: String, CodingKey {
            case list
        }
    }
    
    struct WeatherForecast: Codable {
        let main: WeatherMain
        let weather: [WeatherDetails]
        let wind: WeatherWind
        let dt_txt: String
        
        enum CodingKeys: String, CodingKey {
            case main = "main"
            case weather = "weather"
            case wind = "wind"
            case dt_txt = "dt_txt"
        }
    }
    
    struct WeatherDetails: Codable {
        let main: String
        let icon: String
        
        enum CodingKeys: String, CodingKey {
            case main = "main"
            case icon = "icon"
        }
    }
    
    struct WeatherMain: Codable {
        let temp: Double
        let lowTemp: Double
        let highTemp: Double
        let feelsLike: Double
        let pressure: Double
        let humidity: Double
        
        enum CodingKeys: String, CodingKey {
            case temp
            case lowTemp = "temp_min"
            case highTemp = "temp_max"
            case feelsLike = "feels_like"
            case pressure
            case humidity
        }
    }
    
    struct WeatherWind: Codable {
        let speed: Double
        
        enum CodingKeys: String, CodingKey {
            case speed
        }
    }
    
    static func currentWeather(fromJSON data: Data) -> CurrentWeatherResponse? {
        let decoder = JSONDecoder()
        do {
            let weatherResponse = try decoder.decode(CurrentWeatherResponse.self, from: data)
            return weatherResponse
        } catch let error {
            print("Error creating current weather from JSON because: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func weatherForecast(fromJSON data: Data) -> WeatherForecastResponse? {
        let decoder = JSONDecoder()
        do {
            let forecastResponse = try decoder.decode(WeatherForecastResponse.self, from: data)
            return forecastResponse
        } catch let error {
            print("Error creating weather forecast from JSON because: \(error.localizedDescription)")
            return nil
        }
    }
}
