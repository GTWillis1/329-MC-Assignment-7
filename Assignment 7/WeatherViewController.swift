//
//  WeatherViewController.swift
//  Assignment 7
//
//  Created by Don Hogan on 4/5/19.
//  Copyright © 2019 Garrett Willis. All rights reserved.
//
// MARK: Import statements
import UIKit
import Foundation


class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherDataProtocol {

    // MARK: Outlets
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var bottomButton: UIButton!
    
    
    // MARK: Variables
    var dataSession = WeatherDataSession()
    
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        self.cityTextField.delegate = self
        self.stateTextField.delegate = self
        self.dataSession.delegate = self
        self.bottomButton.setTitle("", for: .normal)
        self.bottomButton.isEnabled = false
    }
    
    
    // MARK: URL formatting, data submission, and data label 
    @IBAction func checkConditions() {

        // Process text field text as necessary and format query dependent on type of entry
        // City + State -> ?q={city},{state}
        // Zipcode -> ?q={zipcode}
        var new_url: String
        let (new_city, _) = convertText(text: cityTextField.text!)
        let (new_state, zip_bool) = convertText(text: stateTextField.text!)
        if zip_bool {
            new_url = new_state
        }
        else {
            new_url = "\(new_city),\(new_state)"
        }
        
        // Clear text entry fields upon submission
        cityTextField.text! = ""
        stateTextField.text! = ""
    
        // Get data from url submission
        self.dataSession.getData(weatherDataLoc: new_url)
    }
    
    // Convert user-entered text into appropriate format for submission to API
    // type = "city" or "state"
    func convertText(text: String) -> (String, Bool) {
        
        var zip_bool = false
        var new_text: String = text.trimmingCharacters(in: .whitespacesAndNewlines)
        new_text = new_text.replacingOccurrences(of: " ", with: "+")
        zip_bool = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: new_text))
        
        print("Formatted text: \(new_text)\nZip bool: \(zip_bool)")
        
        return (new_text, zip_bool)
        
    }
    
    
    // MARK: Weather Data Protocol
    func responseDataHandler(data:NSDictionary) {
        let weatherCond = data["current_conditions"] as! NSDictionary
        let tempF = weatherCond["temp_F"] as! Int
        let tempC = weatherCond["temp_C"] as! Int
        let icon = weatherCond["weatherIconUrl"] as! URL
        let cloudCover = weatherCond["cloudcover"] as! Int
        let humid = weatherCond["humidity"] as! Float
        let pressure = weatherCond["pressure"] as! Int
        let precip = weatherCond["precipMM"] as! Int
        let windSpdKph = weatherCond["windspeedKmph"] as! Int
        let windSpdMph = weatherCond["windspeedMiles"] as! Int
        let windDirDeg = weatherCond["winddirDegree"] as! Int
        let windDirComp = weatherCond["winddir16Point"] as! String
        
        // Run this handling on a separate thread
        DispatchQueue.main.async {
            // Set weather data display elements
            
            // Set hourly forecast button fields
            self.bottomButton.setTitle("Hourly Forecast", for: .normal)
            self.bottomButton.isEnabled = true
        }
    }
    
    func responseError(message: String) {
        // Run this handling on a separate thread
        DispatchQueue.main.async {
            // Set weather data display elements
            
            // Set hourly forecast button fields
            self.bottomButton.setTitle("Current conditions not found", for: .normal)
            self.bottomButton.isEnabled = false
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
