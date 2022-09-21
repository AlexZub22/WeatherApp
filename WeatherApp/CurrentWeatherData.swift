//
//  CurrentWeatherData.swift
//  WeatherApp
//
//  Created by Alexander Zub on 19.09.2022.
//

import Foundation

class CurrenrWeatherData: Decodable {
    var name = ""
    //Данные как в документации на сайте API
    var main = ["temp": 0.0,
                "feelsLike": 0.0,
                "pressure": 0.0,
                "humidity": 0.0]
    var wind = ["speed": 0.0,
                "deg": 0.0]
    
    
}
