//
//  WeatherData.swift
//  Weather & GPS
//
//  Created by Madhu on 29/05/20.
//  Copyright © 2020 Madhu. All rights reserved.
//

import Foundation


// EXTRACTING OUR DATA FROM DECODED DATA

struct WeatherData : Decodable
{
    let name : String
    let main : Main
    let weather : [Weather]
}


struct Main : Decodable
{
    let temp : Double
}

struct Weather : Decodable
{
     let id: Int
}
