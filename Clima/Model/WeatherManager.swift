//
//  WeatherManager.swift
//  Clima
//
//  Created by Jinglun Zhou on 2020/12/26.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=568afaf68497fc9ca87666f13533292a&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees
, longitude:  CLLocationDegrees
) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // create a URL
        if let url = URL(string:urlString) {
            //2. create a URLSession
            let session = URLSession(configuration: .default)
            //3. give the session a task
            // closure, lambda function, call back, after dataTask finished, do lambda functin
            let task = session.dataTask(with: url){(data,response,error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                    
                } else {
                    print("no data")
                }
            }
            
            task.resume()
            
        } else {
            print("URL error")
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self,from:weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            print(decodedData.weather[0].description)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    

    
}
