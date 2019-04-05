//
//  WeatherViewController.swift
//  Assignment 7
//
//  Created by Don Hogan on 4/5/19.
//  Copyright © 2019 Garrett Willis. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Data submission
    @IBAction func checkConditions() {
        
        var new_str = "&q=" + convertText(text: cityTextField.text!, type: "city") + convertText(text: stateTextField.text!, type: "state")
        
    }
    
    
    // Convert user-entered text into appropriate format for submission to API
    // type = "city" or "state"
    func convertText(text: String, type: String) -> String {
        
        var new_text: String = text.trimmingCharacters(in: .whitespacesAndNewlines)
        print("Trimmed text: \(new_text)")
        
        switch type {
            
        case "city":
            break
        case "state":
            break
        default:
            break
            
        }
        
        return new_text
        
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
