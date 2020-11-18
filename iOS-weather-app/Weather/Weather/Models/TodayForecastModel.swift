//
//  TodayModel.swift
//  Weather
//
//  Created by GEOLAB TRAININGS on 2/14/20.
//  Copyright © 2020 GEOLAB TRAININGS. All rights reserved.
//

import Foundation

import UIKit

struct TodayResult: Codable {
    var weather: [TodayWeather]
    var main: TodayMain
    var wind: TodayWind
    var clouds: TodayClouds
    var sys: TodaySys
    var name: String
    
    mutating func configure() {
        self.main.configure()
        self.wind.configure()
    }
}

struct TodayMain: Codable {
    var temp: Double
    var humidity: Double
    var pressure: Double
    
    mutating func configure() {
        self.temp = round(100*(self.temp-273.15))/100.0
        self.humidity = round(100*self.humidity)/100.0
        self.pressure = round(100*self.pressure)/100.0
    }
}

struct TodayWeather: Codable {
    var main: String
    var icon: String
}

struct TodayWind: Codable {
    var speed: Double
    var deg: Double
    
    mutating func configure() { 
        self.speed = round(100*self.speed)/100.0
        self.deg = (self.deg + 22.5) / 45.0
    }
}

struct TodayClouds: Codable {
    var all: Double
}

struct TodaySys: Codable {
    var country: String
}
