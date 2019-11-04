//
//  WeatherResponse.swift
//  AuthorizationApp
//
//  Created by Admin on 04.11.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import Alamofire

class WeatherResponse {
    
    var name = ""
    var temp = 0.0
    var humidity = 0
    var pressure = 0
    
    func currentWeather() {
        
        // send request
        Alamofire.request("https://api.openweathermap.org/data/2.5/weather?q=Moscow&APPID=0955c91429f780ec1b64dacd40ab5471", method: .get).responseJSON { response in
            
            switch response.result {
                
            case .success(let value):
                
                guard let json = value as? [String: Any]
                    else { return }
                
                guard
                    let name = json["name"] as? String
                    else { return }
            
                self.name = name
                
                guard
                    let weather = json["main"] as? [String: Any],
                    let temp = weather["temp"] as? Double,
                    let humidity = weather["humidity"] as? Int,
                    let pressure = weather["pressure"] as? Int
                    
                    else { return }
                let newTemp = temp - 273.15

                self.temp = newTemp
                self.humidity = humidity
                self.pressure = pressure
                
            case .failure(let error):
                print(error)
                print("Error")
            }
        }
    }
    
}
