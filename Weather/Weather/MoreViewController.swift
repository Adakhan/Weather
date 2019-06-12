//
//  MoreViewController.swift
//  Weather
//
//  Created by Adakhanau on 08/06/2019.
//  Copyright © 2019 Adakhan. All rights reserved.
//

/*
import UIKit

class MoreViewController: UIViewController, UITableViewDataSource {
    
    var tempData = DetailedWeather()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        test()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        test()
    }
    
    func test(){
        let jsonUrlString = "http://api.openweathermap.org/data/2.5/forecast?lat=42.874722&lon=74.612222&APPID=079587841f01c6b277a82c1c7788a6c3"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            //perhaps check err
            //also perhaps check response status 200 OK
            
            guard let data = data else { return }
            
            do {
                let informations = try JSONDecoder().decode(DetailedWeather.self, from: data)
                print(informations.cod!+" WORK!!!")
                
                DispatchQueue.main.async {
    
                    self.tempData = informations
                    
                    /*
                    self.conditionImageView.image = UIImage(named: informations.weather[0].icon!)
                    self.conditionLabel.text = informations.weather[0].description
                    
                    self.temperatureLabel.text = String(Int(informations.main.temp! - 273))
                    */
                    
                    
                }
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            
            }.resume()
    }
    /*
    func downloadJson() {
        guard let downloadURL = url else { return }
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("something is wrong")
                return
            }
            print("downloaded")
            do
            {
                let decoder = JSONDecoder()
                let downloadedActors = try decoder.decode(DetailedWeather.self, from: data)
                //self.wCell = downloadedActors.list
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("something wrong after downloaded")
            }
            }.resume()
    }
 */
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempData.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as? WeatherCell else { return UITableViewCell() }
        
//        var temp_min:String = String(format:"%f", 1.0)
        let temp_min = String(Int(tempData.list[indexPath.row].main.temp_min! - 273))
//
//        var temp_max:String = String(format:"%f", 1.0)
        let temp_max = String(Int(tempData.list[indexPath.row].main.temp_max! - 273))
        
        cell.dateLabel.text = tempData.list[indexPath.row].dt_txt
        cell.temperatureLabel.text = "\(temp_min) °C  / \(temp_max) °C"
        
        cell.contentView.backgroundColor = UIColor.darkGray
        cell.backgroundColor = UIColor.darkGray
        
        let checkImageIcon = tempData.list[indexPath.row].weather[0].icon
        var imageIcon = cell.conditionImageView.image
        print(imageIcon!)
        
        if checkImageIcon == "01d" {
            imageIcon = UIImage(named: "Sun.png")
        } else if checkImageIcon == "01n" {
            imageIcon = UIImage(named: "Moon.png")
        } else if checkImageIcon == "02d" {
            imageIcon = UIImage(named: "Cloudly_s.png")
        } else if checkImageIcon == "02n" {
            imageIcon = UIImage(named: "Cloudly_m.png")
        } else if checkImageIcon == "50d" || checkImageIcon == "50n" {
            imageIcon = UIImage(named: "Mist.png")
        } else if checkImageIcon == "09d" || checkImageIcon == "09" {
            imageIcon = UIImage(named: "Rain.png")
        } else if checkImageIcon == "10d" {
            imageIcon = UIImage(named: "Light_rain_s.png")
        } else if checkImageIcon == "10n" {
            imageIcon = UIImage(named: "Light_rain_m.png")
        } else if checkImageIcon == "11d" || checkImageIcon == "11n" {
            imageIcon = UIImage(named: "Thunder.png")
        } else if checkImageIcon == "13d" || checkImageIcon == "13n" {
            imageIcon = UIImage(named: "Snow.png")
        } else {
            imageIcon = UIImage(named: "Clouds.png")
        }
        
        
        return cell
    }
}

 */
