//
//  Model.swift
//  Climate
//
//  Created by Adakhanau on 12/06/2019.
//  Copyright © 2019 Adakhan. All rights reserved.
//

import Foundation

struct DetailedWeather: Decodable {
    var list: [List]?
    var city: City?
}

struct CurrentWeather: Decodable {
    var weather:[Weather]?
    var main: Main?
    var dt: Int?
}

struct List: Decodable {
    var dt: Int?
    var main: Main?
    var weather: [Weather]?
    var dt_txt: String?
}

struct Main: Decodable {
    var temp: Double?
}

struct Weather: Decodable {
    var main: String?
    var description: String?
    var icon: String?
}

struct City: Decodable {
    var name: String?
}
