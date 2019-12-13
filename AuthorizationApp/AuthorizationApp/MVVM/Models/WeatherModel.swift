//
//  WeatherModel.swift
//  AuthorizationApp
//
//  Created by Admin on 12.12.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation

struct WeatherModel: Codable {
    var name: String
    var temp: Double
    var humidity: Int
    var pressure: Int
}

