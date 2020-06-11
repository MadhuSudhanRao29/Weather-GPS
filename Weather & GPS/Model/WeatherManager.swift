//
//  WeatherManager.swift
//  Weather & GPS
//
//  Created by Madhu on 29/05/20.
//  Copyright © 2020 Madhu. All rights reserved.
//

import Foundation
import CoreLocation

//CREATING PROTOLS FOR WEATHER MANAGER

protocol WeatherManagerDelegate
{
    func didUpdateWeather(_ weatherManager:WeatherManager,weather :WeatherModel)
    
    func didFailWithError(error : Error)
    
}


struct WeatherManager
{
    // OPEN WEATHER MAP URL AND API KEY
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=70e07b08dbd54a38443b0e001ab126f4&units=metric"
    
    // ASSIGNING DELEGATE
    var delegate : WeatherManagerDelegate?
    
    
    
    func fetchWeather(cityName:String)
    {
        // ADDING GIVEN CITY NAME
        let finalWeatherURL = "\(weatherURL)&q=\(cityName)"
        print(finalWeatherURL)
        
        // CALLING FUNCTION TO SEND OUR REQUEST
        performRequest(with : finalWeatherURL)
    }
    
    
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    {
        let finalURL = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        
        // CALLING FUNCTION TO SEND OUR REQUEST
        performRequest(with: finalURL)
    }
    
    
    
    func performRequest(with  URLString: String)
    {
        
        if let url = URL(string : URLString)
        {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url)
            {
                (data, response, error) in
                
                if (error != nil)
                {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                
                if let safeData = data
                {
                    // DECODING OUR DATA
                    if let weather = self.parseJSON(safeData)
                    {
                        // TRANSFERING OUR DATA TO MAIN VIEW CONTROLLER
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    
    
    func parseJSON(_ weatherData:Data)->WeatherModel?
    {
        
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from:weatherData)
            
            let name = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            
            print("The Given City Name is :\(name)")
            print("The Temparature in Given City is :\(temp)")
            
            // SENDING OUR DATA TO WEATHER DATA MODEL
            let weather = WeatherModel(cityName: name, temperature: temp,conditionId: id)
            return weather
            
        }
        catch{
            delegate?.didFailWithError(error: error)
            return nil
            
        }
    }
    
    
}

