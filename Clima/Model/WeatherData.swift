//
//  WeatherData.swift
//  Clima
//  Created by Jinglun Zhou on 2020/12/26.
//

import Foundation

struct WeatherData: Codable {
    let name:String
    let main:Main
    let weather:[Weather]
    
}

struct Weather: Codable {
    let description:String
    let id: Int
}

struct Main: Codable {
    let temp:Double
}
