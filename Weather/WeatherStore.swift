//
//  WeatherStore.swift
//  Weather
//
//  Created by Donald Riedl on 11/11/23.
//

import UIKit

enum WeatherError: Error {
    case invalidJSONData
}

class WeatherStore {
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (Result<Weather, Error>) -> Void) {
        let url = WeatherAPI.currentWeatherURL(lat: latitude, lon: longitude)
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            var result = self.processWeatherRequest(data: data, error: error)
            
            if case .success = result {
                do {
                    let weather = try result.get()
                    let iconURL = WeatherAPI.iconURL(icon: weather.icon)
                    let iconRequest = URLRequest(url: iconURL)
                    
                    let iconTask = self.session.dataTask(with: iconRequest) { (data, response, error) in
                        if let data = data, let image = UIImage(data: data) {
                            weather.iconImage = image
                            result = .success(weather)
                        } else {
                            result = .failure(error!)
                        }
                        
                        completion(result)
                    }
                    
                    iconTask.resume()
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(result)
            }
        }
        
        task.resume()
    }
    
    func processWeatherRequest(data: Data?, error: Error?) -> Result<Weather, Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        if let result = WeatherAPI.currentWeather(fromJSON: jsonData) {
            let weather = Weather(
                name: result.name,
                condition: result.weather[0].main,
                icon: result.weather[0].icon,
                temperature: result.main.temp,
                tempLow: result.main.lowTemp,
                tempHigh: result.main.highTemp,
                feelsLike: result.main.feelsLike,
                pressure: result.main.pressure,
                humidity: result.main.humidity,
                windSpeed: result.wind.speed
            )
            return .success(weather)
        } else {
            return .failure(WeatherError.invalidJSONData)
        }
    }
    
    func fetchWeatherForecast(latitude: Double, longitude: Double, completion: @escaping (Result<[Weather], Error>) -> Void) {
        let url = WeatherAPI.weatherForecastURL(lat: latitude, lon: longitude)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            var result = self.processWeatherForecastRequest(data: data, error: error)
            
            if case .success = result {
                do {
                    let weatherArray = try result.get()
                    for weather in weatherArray {
                        let iconURL = WeatherAPI.iconURL(icon: weather.icon)
                        let iconRequest = URLRequest(url: iconURL)
                        
                        let iconTask = self.session.dataTask(with: iconRequest) { (data, response, error) in
                            if let data = data, let image = UIImage(data: data) {
                                weather.iconImage = image
                                result = .success(weatherArray)
                            } else {
                                result = .failure(error!)
                            }
                            
                            completion(result)
                        }
                        
                        iconTask.resume()
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(result)
            }
        }
        
        task.resume()
    }
    
    func processWeatherForecastRequest(data: Data?, error: Error?) -> Result<[Weather], Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        if let result = WeatherAPI.weatherForecast(fromJSON: jsonData) {
            var weatherArray = [Weather]()
            for weatherForecast in result.list {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = dateFormatter.date(from: weatherForecast.dt_txt)
                dateFormatter.dateFormat = "MMM d, HH:mm"
                let dateText = dateFormatter.string(from: date!)
                
                let weather = Weather(
                    name: "",
                    condition: weatherForecast.weather[0].main,
                    icon: weatherForecast.weather[0].icon,
                    temperature: weatherForecast.main.temp,
                    tempLow: weatherForecast.main.lowTemp,
                    tempHigh: weatherForecast.main.highTemp,
                    feelsLike: weatherForecast.main.feelsLike,
                    pressure: weatherForecast.main.pressure,
                    humidity: weatherForecast.main.humidity,
                    windSpeed: weatherForecast.wind.speed,
                    dateText: dateText
                )
                weatherArray.append(weather)
            }
            return .success(weatherArray)
        } else {
            return .failure(WeatherError.invalidJSONData)
        }
    }
}
