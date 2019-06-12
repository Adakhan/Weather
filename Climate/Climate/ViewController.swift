//
//  ViewController.swift
//  Climate
//
//  Created by Adakhanau on 12/06/2019.
//  Copyright © 2019 Adakhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collecView: UICollectionView!
    
    @IBOutlet weak var backView: UIView!
    
    var listWeather = DetailedWeather()
    var todayWeather = CurrentWeather()
    
    var currentTemp: Int = 0
    var dtTime: Int = 0
    
    var checkImage = ""
    var symbol = ""
    
    var index1 = 0
    var index2 = 0
    var index3 = 0
    var index4 = 0
    var index5 = 0
    var index6 = 0
    var index7 = 0
    var index8 = 0

   

    var sortedList:[List] = [List(), List(), List()]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCurrentWeatherJSON()
        loadForecastWeatherJSON()
        
        collecView.dataSource = self
        collecView.delegate = self
        
       
    }
    
    
    
    
    //MARK: - Load JSON
    func loadCurrentWeatherJSON(){
        
        let jsonUrlString = "http://api.openweathermap.org/data/2.5/weather?lat=42.874722&lon=74.612222&APPID=3331e666239ea2e7435b26c22893307c"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            
            do {
                let information = try JSONDecoder().decode(CurrentWeather.self, from: data)
                print("\(String(describing: information.cod)) Current Weather Json is loaded")
                
                DispatchQueue.main.async {
                    self.todayWeather = information
                    self.cityLabel?.text = information.name
                    
                    self.weekDayLabel.text = self.unixTimeToWeekday(unixTime: Double(information.dt!), offset: 0)
                    self.imageView.image = UIImage(named: (information.weather?[0].icon!)!)
                    
                    self.descriptionLabel.text = information.weather?[0].description
                    self.tempLabel.text = String(Int((information.main?.temp!)! - 273))
                    
                    self.currentTemp = (Int(information.main!.temp!) - 273)
                    self.checkImage = (information.weather?[0].icon)!
                    self.collecView.reloadData()
                    
                    if information.weather?[0].icon?.last! == "d" {
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
                    self.listWeather = informations
                    self.dtTime = informations.list![0].dt!
                    
                    let date = Date()
                    let format = DateFormatter()
                    format.dateFormat = "yyyy-MM-dd"
                    let formattedDate = format.string(from: date)
                    
                    for checked in informations.list! {
                        if checked.dt_txt!.prefix(10) != formattedDate {
                            if checked.dt_txt!.suffix(8) == "09:00:00" || checked.dt_txt!.suffix(8) == "21:00:00" {
                                self.sortedList.append(checked)
                                print("Added")
                            }
                        }
                    }
                    print(self.sortedList)
                    print(self.sortedList.count)
                    
                    self.index1 = Int(self.sortedList[3].main!.temp!) - 273
                    self.index2 = Int(self.sortedList[4].main!.temp!) - 273
                    self.index3 = Int(self.sortedList[5].main!.temp!) - 273
                    self.index4 = Int(self.sortedList[6].main!.temp!) - 273
                    self.index5 = Int(self.sortedList[7].main!.temp!) - 273
                    self.index6 = Int(self.sortedList[8].main!.temp!) - 273
                    self.index7 = Int(self.sortedList[9].main!.temp!) - 273
                    self.index8 = Int(self.sortedList[10].main!.temp!) - 273
                    
                    self.collecView.reloadData()
                }
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
    }

    
    
    
    //MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeatherCollectionCell
        
        let temp = currentTemp
        
        if temp < 0 {
            symbol = "-\(temp) °C"
        } else if temp > 0 {
            symbol = "+\(temp) °C"
        } else {
            symbol = "\(temp) °C"
        }
        
        
        
        if indexPath.row == 0 {

            cell.weekdayLabel.text = weekDayLabel.text
            if checkImage.last == "d" {
                cell.dayTempLabel.text = symbol
                cell.nightTempLabel.text = ""
                
            } else if checkImage.last == "n" {
                cell.dayTempLabel.text = ""
                cell.nightTempLabel.text = symbol
            }
        } else if indexPath.row == 1 {
            
            cell.weekdayLabel.text = unixTimeToWeekday(unixTime: Double(dtTime), offset: 1)
            
            cell.dayTempLabel.text = String(index1)
            cell.nightTempLabel.text = String(index2)
            
        } else if indexPath.row == 2 {
            cell.weekdayLabel.text = unixTimeToWeekday(unixTime: Double(dtTime), offset: 2)
            
            cell.dayTempLabel.text = String(index3)
            cell.nightTempLabel.text = String(index4)
        } else if indexPath.row == 3 {
            cell.weekdayLabel.text = unixTimeToWeekday(unixTime: Double(dtTime), offset: 3)
            
            cell.dayTempLabel.text = String(index5)
            cell.nightTempLabel.text = String(index6)
        } else if indexPath.row == 4 {
            cell.weekdayLabel.text = unixTimeToWeekday(unixTime: Double(dtTime), offset: 4)
            
            cell.dayTempLabel.text = String(index7)
            cell.nightTempLabel.text = String(index8)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
    
    // MARK: - Background View
    func setBlueGradientBackground(){
        backView.backgroundColor = UIColor(red: 1.0/255.0, green: 150.0/255.0, blue: 255.0, alpha: 1.0)
    }
    
    func setGreyGradientBackground(){
        backView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
    
    
    //MARK: - Time
    func currentWeekday() -> String {
        let today = DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: Date())-1]
        return today
    }
    
    func unixTimeToWeekday(unixTime: Double, timeZone: String = "Kazakhstan/Almaty", offset: Int) -> String {
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

