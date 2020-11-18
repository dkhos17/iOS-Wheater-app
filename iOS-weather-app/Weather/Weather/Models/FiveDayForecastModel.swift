//
//  FiveDayForecastModel.swift
//  Weather
//
//  Created by GEOLAB TRAININGS on 2/12/20.
//  Copyright © 2020 GEOLAB TRAININGS. All rights reserved.
//

import UIKit

struct ForecastResult: Codable {
    let list: [ForecastList]
}

struct ForecastList: Codable {
    let dt_txt: String
    let main: ForecastMain
    let weather: [ForecastWeather]
}

struct ForecastMain: Codable {
    let temp: Double
}

struct ForecastWeather: Codable {
    let icon: String
    let description: String
}

