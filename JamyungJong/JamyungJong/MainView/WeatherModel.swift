//
//  WeatherModel.swift
//  JamyungJong
//
//  Created by YangJeongMu on 1/8/25.
//

import Foundation

struct WeatherModel: Codable {
    let weather: [Weather]
    let main: WeatherMain
    let name: String?
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
}

struct WeatherMain: Codable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
    
}
