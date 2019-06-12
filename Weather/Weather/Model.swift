//
//  Model.swift
//  Weather
//
//  Created by Adakhanau on 05/06/2019.
//  Copyright © 2019 Adakhan. All rights reserved.
//

import Foundation

struct DetailedWeather: Decodable {
    var cod: String?
    var message: Double?
    var cnt: Int?
    var list: [List]?
    var city: City?
}

struct CurrentWeather: Decodable {
    var coord: Coordinate?
    var weather:[Weather]?
    var base: String?
    var main: Mainx?
    var visibility: Int?
    var wind: Wind?
    var clouds: Cloud?
    var dt: Int?
    var sys: Sysx?
    var timezone: Int?
    var id: Int?
    var name: String?
    var cod: Int?
}

struct List: Decodable {
    var dt: Int?
    var main: Main?
    var weather: [Weather]?
    var clouds: Cloud?
    var wind: Wind?
    var sys: Sys?
    var dt_txt: String?
}

struct Main: Decodable {
    var temp: Double?
    var temp_min: Double?
    var temp_max: Double?
    var pressure: Double?
    var sea_level: Double?
    var grnd_level: Double?
    var humidity: Int?
    var temp_kf: Double?
}

struct Weather: Decodable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}

struct Cloud: Decodable {
    var all: Int?
}

struct Wind: Decodable {
    var speed: Double?
    var deg: Double?
}

struct Sys: Decodable {
    var pod: String?
}

struct City: Decodable {
    var id: Int?
    var name: String?
    var coord: Coordinate?
    var country: String?
    var population: Int?
    var timezone: Int?
}

struct Coordinate: Decodable {
    var lat: Double?
    var lan: Double?
}

struct Mainx: Decodable {
    var temp: Double?
    var pressure: Double?
    var humidity: Int?
    var temp_min: Double?
    var temp_max: Double?
}

struct Sysx: Decodable {
    var type: Int?
    var id: Int?
    var message: Double?
    var country: String?
    var sunrise: Int?
    var sunset: Int?
}
