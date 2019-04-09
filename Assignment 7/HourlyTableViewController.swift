//
//  HourlyTableViewController.swift
//  Assignment 7
//
//  Created by Don Hogan on 4/8/19.
//  Copyright © 2019 Garrett Willis. All rights reserved.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var humidLabel: UILabel!
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
}

class HourlyTableViewController: UITableViewController {

    // MARK: Variables
    var hourlyData = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hourly Forecast"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.hourlyData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HourCell", for: indexPath) as! HourlyTableViewCell
        
        // Retrieve and store weather data
        let hourIndex = indexPath.section
        let hourData = self.hourlyData[hourIndex]
        let tempC = hourData["tempC"] as! String
        let tempF = hourData["tempF"] as! String
        let humidity = hourData["humidity"] as! String
        let rainChance = hourData["chanceofrain"] as! String
        let cloud = hourData["cloudcover"] as! String
        let windKmph = hourData["windspeedKmph"] as! String
        let windMph = hourData["windspeedMiles"] as! String
        let windComp = hourData["winddir16Point"] as! String
        let windDeg = hourData["winddirDegree"] as! String
        
        // Retrieve and load icon image
        let iconArray = hourData["weatherIconUrl"] as? NSArray
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
                            cell.iconImage.image = iconImg!
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
        
        // Set cell labels to display data
        DispatchQueue.main.async{
            cell.tempLabel.text = tempC + "°C/" + tempF + "°F"
            cell.cloudLabel.text = cloud + "%"
            cell.humidLabel.text = humidity + "%"
            cell.rainLabel.text = rainChance + "%"
            cell.windLabel.text = windKmph + "kmph/" + windMph + "mph " + windComp + " (" + windDeg + "°)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let hourData = self.hourlyData[section]
        let time = hourData["time"] as! String
        var timeStr:String? = nil
        switch Int(time)! {
            
        case 0...1199: timeStr = "\(time.prefix(1)):00 a.m."
        case 1200: timeStr = "12:00 p.m."
        case 1201...2401: timeStr = "\((Int(time)!/100)-12):00 p.m"
        
        default:
            timeStr = "ERROR"
        }
    
        return timeStr
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
