//
//  WeatherViewController.swift
//  Weather
//
//  Created by Donald Riedl on 11/11/23.
//

import UIKit
import MapKit

class WeatherViewController: UITableViewController {
    var receivedCoordinates: CLLocationCoordinate2D?
    var store = WeatherStore()
    var weather: Weather? {
        didSet {
            // Set Current Temperature Details
            navigationItem.title = weather?.name
            weatherIconImage.image = weather?.iconImage
            tempLabel.text = "\(weather?.temperature ?? 0)ºF"
            conditionLabel.text = weather?.condition
            detailsLabel.text = "\(weather?.tempLow ?? 0)/\(weather?.tempHigh ?? 0) feels like \(weather?.feelsLike ?? 0)"
            humidityLabel.text = "\(weather?.humidity ?? 0)%"
            windSpeedLabel.text = "\(weather?.windSpeed ?? 0) mph"
        }
    }
    var forecast: [Weather]? {
        didSet {
            checkStatus()
        }
    }
    
    func checkStatus() {
        if forecast != nil && weather != nil {
            spinner.stopAnimating()
            spinner.isHidden = true
            currentWeatherSection.isHidden = false
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var currentWeatherSection: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var weatherIconImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let selectedCoordinates = receivedCoordinates {
            print(selectedCoordinates)
            store.fetchWeather(latitude: selectedCoordinates.latitude, longitude: selectedCoordinates.longitude) { (result) in
                switch result {
                case let .success(weather):
                    DispatchQueue.main.async {
                        self.weather = weather
                    }
                case let .failure(error):
                    print("Error fetching weather: \(error)")
                }
            }
            store.fetchWeatherForecast(latitude: selectedCoordinates.latitude, longitude: selectedCoordinates.longitude) { (result) in
                switch result {
                case let .success(weather):
                    DispatchQueue.main.async {
                        self.forecast = weather
                    }
                case let .failure(error):
                    print("Error fetching weather: \(error)")
                }
            }
        }
    }
    
    // Make forecast the data source for the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast?.count ?? 0
    }
    
    // Populate the table with forecast data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastCellController
        
        if let forecast = forecast?[indexPath.row] {
            cell.iconImage.image = forecast.iconImage
            cell.dateLabel.text = forecast.dateText
            cell.conditionLabel.text = forecast.condition
            cell.highTempLabel.text = "\(forecast.tempHigh)ºF"
            cell.lowTempLabel.text = "\(forecast.tempLow)ºF"
            cell.windLabel.text = "\(forecast.windSpeed) mph"
            cell.humidityLabel.text = "\(forecast.humidity)%"
        }
        
        return cell
    }
}
