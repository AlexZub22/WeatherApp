//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Alexander Zub on 19.09.2022.
//

import Foundation

class NetworkManager {
    
    private let apiKey = "5be21c260f2fd516cd7e230cd70c942a"
    static let shared = NetworkManager()
    
    private init() { }
    
    func getRequest(city: String, completion: @escaping (_ weather: CurrenrWeatherData) -> ()) { //если сделать возвращаемое значение то не успеет обработаться запрос и вернется nil, поэтому реализовано через сбегающее замыкание
        let tunnel = "https://"
        let domain = "api.openweathermap.org"
        let method = "/data/2.5/weather"
        let parameters = "?q=\(city)&appid=\(apiKey)"
        let urlString = tunnel + domain + method + parameters
        
        guard let url = URL(string: urlString) else {
            print("URL invalid")
            return
        }
        let session = URLSession.shared // Синглтон
        session.dataTask(with: url) { data, response, error in
            
            guard let response = response, let data = data else {
            print("Ответа от сервера нет, данные не получены")
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            //печатаем данные из запроса
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                
                let decoder = JSONDecoder() //создаем декодер
                decoder.keyDecodingStrategy = .convertFromSnakeCase //в кэмэл кейс
                
                let weather = try decoder.decode(CurrenrWeatherData.self, from: data) // типы данных должны соответсвовать double к double
                
                // вызываем сбегающее замыкание и захватываем погоду
                completion(weather)
                
                
            } catch {
                print(error.localizedDescription)
            }
            
            //Декодируем json в модель currentweatherdata
            
        }.resume() //для запуска задачи!
        
    }
    
}
