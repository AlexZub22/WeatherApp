//
//  ViewController.swift
//  WeatherApp
//
//  Created by Alexander Zub on 19.09.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var massureSegment: UISegmentedControl!
   //Таблица
    @IBOutlet weak var tableView: UITableView!
    
    
    var weather: CurrenrWeatherData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentWeather(city: "Moscow")
    }
    
    func getTempString(weather: CurrenrWeatherData) -> String {
        switch self.massureSegment.selectedSegmentIndex {
        case 0:
            let tempInCelsius = Int(weather.main["temp"]! - 273)
            let tempString = (tempInCelsius > 0) ? "+\(tempInCelsius) C" : "-\(tempInCelsius) C"
            return tempString
        case 1:
            let tempInCelsius = Int(weather.main["temp"]! - 273)
            let tempInFahr = 2 * tempInCelsius + 32
            let tempString = (tempInFahr > 0) ? "+\(tempInFahr) F" : "-\(tempInFahr) F"
            return tempString
        case 2:
            let tempString = "\(Int(weather.main["temp"]!)) K"
            return tempString
        default: return ""
        }
    }
    
    func getCurrentWeather(city: String) {
        NetworkManager.shared.getRequest(city: city) {
            weather in
            
            self.weather = weather
            
            //Изменение интерфейса должно происходить в главном потоке. Главный поток нагружается только измениями интерфейса (главная очередь)
            DispatchQueue.main.async {
                self.cityLabel.text = weather.name
                
               
                
                self.tempLabel.text = self.getTempString(weather: weather)
               
                let dir = self.getDirection(deg: weather.wind["deg"]!)
                
                self.windLabel.text = "\(dir) \(weather.wind["speed"]!) м/с"
                
            }
        }
    }
    
   func getDirection(deg: Double) -> String { // Добавить более детальные направления ветра
       switch deg {
       case 0..<22:
           return "Север"
       case 22..<68:
           return "Cеверо - восток"
       case 68..<112:
           return "Восток"
       case 112..<158:
           return "Юго - восток"
       case 158..<202:
           return "Юг"
       case 202..<248:
           return "Юго - запад"
       case 248..<292:
           return "Запад"
       case 292..<338:
           return "Cеверо - запад"
       case 338..<360:
           return "Cевер"
       default: return ""
       }
    }

    @IBAction func requestTap(_ sender: Any) {
        guard let city = cityTextField.text else {
            return
        }
        self.getCurrentWeather(city: city)
    }
    
    @IBAction func changeMessure(_ sender: UISegmentedControl) {
        guard let weather = weather else {
            return
        }
        self.tempLabel.text = getTempString(weather: weather)
    }
    
}

