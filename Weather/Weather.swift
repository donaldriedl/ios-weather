//
//  Weather.swift
//  Weather
//
//  Created by Donald Riedl on 11/11/23.
//

import Foundation
import UIKit

class Weather {
    let name: String
    let condition: String
    let icon: String
    let temperature: Int
    let tempLow: Int
    let tempHigh: Int
    let feelsLike: Int
    let pressure: Int
    let humidity: Int
    let windSpeed: Int
    let dateText: String
    
    init(
        name: String,
        condition: String,
        icon: String,
        temperature: Double,
        tempLow: Double,
        tempHigh: Double,
        feelsLike: Double,
        pressure: Double,
        humidity: Double,
        windSpeed: Double,
        dateText: String = ""
    ) {
        self.name = name
        self.condition = condition
        self.icon = icon
        self.temperature = Int(temperature)
        self.tempLow = Int(tempLow)
        self.tempHigh = Int(tempHigh)
        self.feelsLike = Int(feelsLike)
        self.pressure = Int(pressure)
        self.humidity = Int(humidity)
        self.windSpeed = Int(windSpeed)
        self.dateText = dateText
    }
    
    var iconImage: UIImage?
}
