//
//  WeatherDataSession.swift
//  Assignment 7
//
//  Created by Don Hogan on 4/6/19.
//  Copyright © 2019 Garrett Willis. All rights reserved.
//

import UIKit

protocol WeatherDataProtocol {
    func responseDataHandler(data:NSDictionary)
    func responseError(message:String)
}

class WeatherDataSession {
    private let apiKey = "2bd33f8903034accad2173956190604"
    private let urlSession = URLSession.shared
    private let urlPathBase = "https://api.worldweatheronline.com/premium/v1/weather.ashx"
    
    private var dataTask:URLSessionDataTask? = nil
    
    var delegate:WeatherDataProtocol? = nil
    
    init() {}
    
    func getData(weatherDataLoc:String) {
        
        let urlPath = "\(self.urlPathBase)?key=\(self.apiKey)&format=json&q=\(weatherDataLoc)"
        print(urlPath)
        
        let url = URL(string: urlPath)
        
        let dataTask = self.urlSession.dataTask(with: url!) { (data, response, error) -> Void in
            if error != nil {
                print(error!)
            } else {
                do {
                    if response != nil {
                        print("Received response: \(response!)")
                    }
                    let jsonResult = try JSONSerialization.jsonObject(with:data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    if jsonResult != nil {
                        let resultData = jsonResult!["data"] as? NSDictionary
                        let weatherCond = resultData!["current_condition"] as? NSArray
                        if weatherCond != nil {
                            let currentCond = weatherCond![0] as? NSDictionary
                            //print("Current conditions:\n\(currentCond!)")
                            self.delegate?.responseDataHandler(data: currentCond!)
                        } else {
                            self.delegate?.responseError(message: "Current conditions not found")
                        }
                    }
                } catch {
                    
                }
            }
        }
        dataTask.resume()
    }
}
