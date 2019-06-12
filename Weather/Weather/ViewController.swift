//
//  ViewController.swift
//  Weather
//
//  Created by Adakhanau on 05/06/2019.
//  Copyright © 2019 Adakhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet var celsius: UILabel!
    
    @IBOutlet weak var collView: UICollectionView!
    
    
    var listWeather = DetailedWeather()
    var todayWeather = CurrentWeather()
    var weekList = [List]()
    
    var currentTemp: Int = 0
    var currentOtherTemp: Int = 0
    var checkImage = ""
    var dtTime = 0
    var movableIndex = 8
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCurrentWeatherJSON()
        loadForecastWeatherJSON()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        collView.delegate = self
        collView.dataSource = self
     
        collView.register(UINib(nibName: "WeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WeatherCell");
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCollectionViewCell
        
        let array = weekList
        
        let temp = currentTemp
        var symbol = ""
        if temp < 0 {
            symbol = "-"
        } else if temp > 0 {
            symbol = "+"
        } else {
            symbol = " "
        }
        
        if indexPath.row == 0 {
            
          
            cell.weekdayLabel.text = currentWeekday()
            
            if checkImage.last == "d" {
                
                cell.dayTempLabel.text = " Day "
                cell.nightTempLabel.text = " Night "
            
                cell.dayTempLabel.text = cell.dayTempLabel.text! + symbol + String(temp) + " °C"
                cell.nightTempLabel.text = ""
                
            } else if checkImage.last == "n" {
                cell.nightTempLabel.text = cell.nightTempLabel.text! + symbol + String(temp) + " °C"
                cell.dayTempLabel.text = ""
            }
            
        } else if indexPath.row == 1 {
            
            let dayTemp = (Int((array[0].main?.temp)!) - 273)
            if dayTemp < 0 {
                symbol = "-"
            } else if dayTemp > 0 {
                symbol = "+"
            } else {
                symbol = " "
            }
//
//            let nightTemp = (Int((array[1].main?.temp)!) - 273)
//            if nightTemp < 0 {
//                symbol = "-"
//            } else if nightTemp > 0 {
//                symbol = "+"
//            } else {
//                symbol = " "
//            }
//
            cell.dayTempLabel.text = " Day "
            cell.nightTempLabel.text = " Night "
            
            cell.dayTempLabel.text = cell.dayTempLabel.text! + symbol + String(dayTemp) + " °C"
            cell.nightTempLabel.text = cell.nightTempLabel.text! + symbol + String(dayTemp) + " °C"
            
            cell.weekdayLabel.text = unixTimeToWeekday(unixTime: Double(dtTime), timeZone: "Kazakhstan/Almaty", offset: 0)
        
        } else if indexPath.row == 2 {
            cell.dayTempLabel.text = " Day "
            cell.nightTempLabel.text = " Night "
            
            cell.weekdayLabel.text = unixTimeToWeekday(unixTime: Double(dtTime), timeZone: "Kazakhstan/Almaty", offset: 1)
        } else if indexPath.row == 3 {
            cell.dayTempLabel.text = " Day "
            cell.nightTempLabel.text = " Night "
            cell.weekdayLabel.text = unixTimeToWeekday(unixTime: Double(dtTime), timeZone: "Kazakhstan/Almaty", offset: 2)
        } else if indexPath.row == 4 {
            cell.dayTempLabel.text = " Day "
            cell.nightTempLabel.text = " Night "
            cell.weekdayLabel.text = unixTimeToWeekday(unixTime: Double(dtTime), timeZone: "Kazakhstan/Almaty", offset: 3)
        }

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
    
    // MARK: - Parsing Json Functions
    
    func loadCurrentWeatherJSON(){
        
        let jsonUrlString = "http://api.openweathermap.org/data/2.5/weather?lat=42.874722&lon=74.612222&APPID=3331e666239ea2e7435b26c22893307c"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            
            do {
                let informations = try JSONDecoder().decode(CurrentWeather.self, from: data)
                print("\(String(describing: informations.cod)) Current Weather Json is loaded")
                
                DispatchQueue.main.async {
                    self.todayWeather = informations
                    self.locationLabel?.text = informations.name
                    
                    self.dayLabel.text = self.currentWeekday()
                    self.conditionImageView.image = UIImage(named: (informations.weather?[0].icon!)!)
                    
                    self.conditionLabel.text = informations.weather?[0].description
                    self.temperatureLabel.text = String(Int((informations.main?.temp!)! - 273))
                    
                    self.currentTemp = (Int(informations.main!.temp!) - 273)
                    self.checkImage = (informations.weather?[0].icon)!
                    
                    self.collView.reloadData()
        
                    
                    if informations.weather?[0].icon?.last! == "d" {
                        self.setBlueGradientBackground()
                    } else {
                        self.setGreyGradientBackground()
                    }
                    
                }
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            
            }.resume()
    }
    
    func loadForecastWeatherJSON(){
        
        let jsonUrlString = "http://api.openweathermap.org/data/2.5/forecast?lat=42.874722&lon=74.612222&APPID=079587841f01c6b277a82c1c7788a6c3"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            
            do {
                let informations = try JSONDecoder().decode(DetailedWeather.self, from: data)
                print("\(String(describing: informations.cod)) Forecast Weather Json is loaded")
                
                DispatchQueue.main.async {
                    
                    let date = Date()
                    let format = DateFormatter()
                    format.dateFormat = "yyyy-MM-dd"
                    let formattedDate = format.string(from: date)

                    for checked in informations.list! {
                        if checked.dt_txt!.suffix(8) == "15:00:00" || checked.dt_txt!.suffix(8) == "03:00:00" && checked.dt_txt!.prefix(10) != formattedDate {
                            self.weekList.append(checked)
                            print("Added")
                        }
                    }
                    
                    self.dtTime = informations.list![self.movableIndex].dt!
                    self.listWeather = informations
                    
                    self.weekList = informations.list!
                    self.collView.reloadData()
                    
                    
                }
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            
            }.resume()
    }
    
    
    
    // MARK: - Background View
    func setBlueGradientBackground(){
        backgroundView.backgroundColor = UIColor(red: 1.0/255.0, green: 150.0/255.0, blue: 255.0, alpha: 1.0)
    }
    
    func setGreyGradientBackground(){
        backgroundView.backgroundColor = UIColor(red: 94.0/255.0, green: 94.0/255.0, blue: 94.0/255.0, alpha: 1.0)
    }
    
    
    func currentWeekday() -> String {
        let today = DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: Date())-1]
        return today
    }
    
    
    func unixTimeToWeekday(unixTime: Double, timeZone: String, offset: Int) -> String {
        if(timeZone == "" || unixTime == 0.0) {
            return ""
        } else {
            let time = Date(timeIntervalSince1970: unixTime)
            var cal = Calendar(identifier: .gregorian)
            if let tz = TimeZone(identifier: timeZone) {
                cal.timeZone = tz
            }
            // Get the weekday for the given timezone.
            // Add the offset
            // Subtract 1 to convert from 1-7 to 0-6
            // Normalize to 0-6 using % 7
            let weekday = (cal.component(.weekday, from: time) + offset - 1) % 7
            
            // Get the weekday name for the user's locale
            return Calendar.current.weekdaySymbols[weekday]
        }
    }
    
    
}

