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
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Location entry and submission elements
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var bottomButton: UIButton!
    
    // Static fields containing condition names
    @IBOutlet weak var cloudFieldLabel: UILabel!
    @IBOutlet weak var humidFieldLabel: UILabel!
    @IBOutlet weak var pressureFieldLabel: UILabel!
    @IBOutlet weak var precipFieldLabel: UILabel!
    @IBOutlet weak var windFieldLabel: UILabel!
    
    // Dynamic fields containing weather data
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var precipLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    // MARK: Variables
    private var dataSession = WeatherDataSession()
    private var weatherNameLabels = [UILabel]()
    private var weatherDataLabels = [UILabel]()
    var hourData = [NSDictionary]()
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Current Conditions"
        
        // Do any additional setup after loading the view
        self.cityTextField.delegate = self
        self.stateTextField.delegate = self
        self.dataSession.delegate = self
        self.bottomButton.setTitle("", for: .normal)
        self.bottomButton.isEnabled = false
        let viewWidth = UIScreen.main.bounds.width - 200
        let viewHeight = UIScreen.main.bounds.height + 200
        self.scrollView.contentSize = CGSize(width: CGFloat(viewWidth), height: CGFloat(viewHeight))
        
        // Hide weather display at start
        self.iconImage.isHidden = true
        self.weatherNameLabels.append(self.cloudFieldLabel)
        self.weatherNameLabels.append(self.humidFieldLabel)
        self.weatherNameLabels.append(self.pressureFieldLabel)
        self.weatherNameLabels.append(self.precipFieldLabel)
        self.weatherNameLabels.append(self.windFieldLabel)
        for label in self.weatherNameLabels as [UILabel] {
            label.isHidden = true
        }
        self.weatherDataLabels.append(self.tempLabel)
        self.weatherDataLabels.append(self.cloudLabel)
        self.weatherDataLabels.append(self.humidityLabel)
        self.weatherDataLabels.append(self.pressureLabel)
        self.weatherDataLabels.append(self.precipLabel)
        self.weatherDataLabels.append(self.windLabel)
        for label in self.weatherDataLabels as [UILabel] {
            label.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHourly" {
            let hourlyVC = segue.destination as! HourlyTableViewController
            hourlyVC.hourlyData = self.hourData
        }
    }
    
    @IBAction func showHourlyWeather(_ sender: Any) {
    
        self.performSegue(withIdentifier: "showHourly", sender: sender)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /*
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        super.willRotate(to: toInterfaceOrientation, duration: duration)
        if toInterfaceOrientation == UIInterfaceOrientationPortrait {
            
        }
        let viewWidth = UIScreen.main.bounds.width - 200
        let viewHeight = UIScreen.main.bounds.height + 200
        self.scrollView.contentSize = CGSize(width: CGFloat(viewWidth), height: CGFloat(viewHeight))
    }
    */
    
    // MARK: URL formatting, data submission, and data label 
    @IBAction func checkConditions() {
        
        self.cityTextField.resignFirstResponder()
        self.stateTextField.resignFirstResponder()
        
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
    
        // Get data from url submission
        self.dataSession.getData(weatherDataLoc: new_url)
    }
    
    // Convert user-entered text into appropriate format for submission to API
    // type = "city" or "state"
    func convertText(text: String) -> (String, Bool) {
        
        var zip_bool = false
        var new_text: String = text.trimmingCharacters(in: .whitespacesAndNewlines)
        new_text = new_text.replacingOccurrences(of: " ", with: "+")
        zip_bool = (CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: new_text))) && (text.count == 5)
        
        print("Formatted text: \(new_text)\nZip bool: \(zip_bool)")
        
        return (new_text, zip_bool)
        
    }
    
    
    // MARK: Weather Data Protocol
    func responseDataHandler(currentData:NSDictionary, hourlyData:NSArray) {
        // Retrieve current weather data
        let tempF = currentData["temp_F"] as! String
        let tempC = currentData["temp_C"] as! String
        let cloudCover = currentData["cloudcover"] as! String
        let humid = currentData["humidity"] as! String
        let pressure = currentData["pressure"] as! String
        let precip = currentData["precipMM"] as! String
        let windSpdKph = currentData["windspeedKmph"] as! String
        let windSpdMph = currentData["windspeedMiles"] as! String
        let windDirDeg = currentData["winddirDegree"] as! String
        let windDirComp = currentData["winddir16Point"] as! String
        
        // Download current weather icon and store in image view
        let iconArray = currentData["weatherIconUrl"] as? NSArray
        let iconDict = iconArray![0] as? NSDictionary
        let iconURL = URL(string: iconDict!["value"] as! String)
        let session = URLSession(configuration: .default)
        let downloadIconTask = session.dataTask(with: iconURL!) { (data, response, error) in
            if error != nil {
                print("Error downloading weather icon: \(error!)")
            } else {
                if response != nil {
                    if let imageData = data {
                        let iconImg = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self.iconImage.image = iconImg!
                        }
                    } else {
                        print("Couldn't get icon image; image is nil")
                    }
                } else {
                    print("Couldn't get response code somehow")
                }
            }
        }
        downloadIconTask.resume()
        
        // Store hourly data for processing to be performed when loading hourly forecast view
        self.hourData = hourlyData as! [NSDictionary]
        
        // Run this handling on a separate thread
        DispatchQueue.main.async {
            // Unhide view elements
            self.iconImage.isHidden = false
            for label in self.weatherNameLabels as [UILabel] {
                label.isHidden = false
            }
            for label in self.weatherDataLabels as [UILabel] {
                label.isHidden = false
            }
            
            // Set weather data display elements
            self.tempLabel.text = tempC + "°C/" + tempF + "°F"
            self.cloudLabel.text = cloudCover + "%"
            self.humidityLabel.text = humid + "%"
            self.pressureLabel.text = pressure + "mbar"
            self.precipLabel.text = precip + "mm"
            self.windLabel.text = windSpdKph + "kmph/" + windSpdMph + "mph " + windDirComp + " (" + windDirDeg + "°)"
            
            // Set hourly forecast button fields
            self.bottomButton.setTitle("Hourly Forecast", for: .normal)
            self.bottomButton.isEnabled = true
        }
 
    }
    
    func responseError(message: String) {
        // Run this handling on a separate thread
        DispatchQueue.main.async {
            // Hide weather data display elements
            self.iconImage.isHidden = true
            for label in self.weatherNameLabels as [UILabel] {
                label.isHidden = true
            }
            for label in self.weatherDataLabels as [UILabel] {
                label.isHidden = true
            }
            
            // Set hourly forecast button fields
            self.bottomButton.setTitle("Current conditions not found", for: .normal)
            self.bottomButton.isEnabled = false
            self.bottomButton.setTitleColor(UIColor.black, for: .normal)
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
