//
//  ViewController.swift
//  Weather & GPS
//
//  Created by Madhu on 28/05/20.
//  Copyright © 2020 Madhu. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController
{
    
    // CREATING INSTANCES FOR WEATHER & LOCATION MANAGER
    var locationManager   = CLLocationManager()
    var weatherManager    =  WeatherManager()
    
    
    // CREATING OUTLETS FOR EACH
    @IBOutlet weak var imageView          : UIImageView!
    @IBOutlet weak var temparatureLabel   : UILabel!
    @IBOutlet weak var cityNameLabel      : UILabel!
    @IBOutlet weak var searchTextField    : UITextField!
    
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // ASSIGNING DELEGATE FOR LOCATION MANAGER & REQUESTING LOCATION
        locationManager.delegate   = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // ASSIGNING DELEGATE FOR WEATHER MANAGER & TEXT FIELD
        weatherManager.delegate    = self
        searchTextField.delegate   = self
    }
    
    
}

// REALTED TO TEXT FIELD AND SEARCH BUTTON

extension ViewController:UITextFieldDelegate
{
    
    @IBAction func searchButtonPressed(_ sender: UIButton)
    {
        searchTextField.endEditing(true)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.endEditing(true)
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        if textField.text != ""
        {
            return true
        }
        else
        {
            textField.placeholder = "Search Something"
            return false
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if let cityName = searchTextField.text
        {
            weatherManager.fetchWeather(cityName: cityName)
        }
        
        searchTextField.text = ""
    }
}



// RELATED TO WEATHER MANAGER DATA

extension ViewController: WeatherManagerDelegate
{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    {
        DispatchQueue.main.async
            {
                self.temparatureLabel.text   = weather.temperature1
                self.imageView.image         = UIImage(systemName: weather.conditionName)
                self.cityNameLabel.text      = weather.cityName
        }
        
    }
    
    func didFailWithError(error: Error)
    {
        print(error)
    }
}




// RELATED TO LOCATION MANAGER

extension ViewController : CLLocationManagerDelegate
{
    
    @IBAction func locButtonPressed(_ sender: UIButton)
    {
        locationManager.requestLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.last
        {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat , longitude : lon)
            
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
    }
}
