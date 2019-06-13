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
    
 
    var currentData = CurrentWeather()
    var currentTemp: Int = 0
    var dtTime: Int = 0
    
    var checkImage = ""
    
    var dayList: [List] = []
    var nightList: [List] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCurrentWeather()
        loadForecastWeather()
        initSetUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //auto selected 1st item
        let indexPathForFirstRow = IndexPath(row: 0, section: 0)
        self.collecView?.selectItem(at: indexPathForFirstRow, animated: true, scrollPosition: .top)
    }
    

    func initSetUp() {
        collecView.dataSource = self
        collecView.delegate = self
    }
    
    
    
    //MARK: - Load JSON
    func loadCurrentWeather(){
        ServerManager.shared.loadCurrentWeather(completion: UpdateCurrentData)
    }
    
    func loadForecastWeather(){
        ServerManager.shared.loadForecastWeather(completion: UpdateForecastData)
    }
    
    
    func UpdateCurrentData(information: CurrentWeather){
        self.currentData = information
        self.cityLabel?.text = information.name
        
        self.weekDayLabel.text = information.dt?.toWeekday(0)
        self.imageView.image = UIImage(named: (information.weather?[0].icon!)!)
        
        self.descriptionLabel.text = information.weather?[0].description
        self.tempLabel.text = String(information.main!.temp!.toSelcius())
        
        self.currentTemp = (information.main!.temp!.toSelcius())
        self.checkImage = (information.weather?[0].icon)!
        self.collecView.reloadData()
        
        if information.weather?[0].icon?.last! == "d" {
            self.setBlueGradientBackground()
        } else {
            self.setBlackGradientBackground()
        }
    }
    
    func UpdateForecastData(informations: DetailedWeather){
        
        self.dtTime = informations.list![4].dt!
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        
        
        for checked in informations.list! {
            if checked.dt_txt!.prefix(10) != formattedDate {
                if checked.dt_txt!.suffix(8) == "09:00:00" {
                    self.dayList.append(checked)
                } else if checked.dt_txt!.suffix(8) == "21:00:00" {
                    self.nightList.append(checked)
                }
            }
        }
        
        self.collecView.reloadData()
    }
    
   

    //MARK: - Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeatherCollectionCell
        
        if dayList.isEmpty {
            return cell
        }
        
        let temp = currentTemp
        
        cell.weekdayLabel.text = dtTime.toWeekday(indexPath.row)
        
        if indexPath.row == 0 {

            if checkImage.last == "d" {
                cell.dayTempLabel.text = temp.toStr()
                cell.nightTempLabel.text = ""
                
            } else if checkImage.last == "n" {
                cell.dayTempLabel.text = ""
                cell.nightTempLabel.text = temp.toStr()
            }
            
        } else {
            cell.dayTempLabel.text = dayList[indexPath.row-1].main!.temp!.toSelcius().toStr()
            cell.nightTempLabel.text = nightList[indexPath.row-1].main!.temp!.toSelcius().toStr()
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        weekDayLabel.text = dtTime.toWeekday(indexPath.row)
        weekDayLabel.highlightedTextColor = UIColor.red
        
        if indexPath.row == 0 {
            if checkImage.last == "d" {
                descriptionLabel.text = currentData.weather![0].description
                tempLabel.text = String(dayList[indexPath.row].main!.temp!.toSelcius())
                imageView.image = UIImage(named: dayList[indexPath.row].weather![0].icon!)
                
            } else if checkImage.last == "n" {
                descriptionLabel.text = currentData.weather![0].description
                tempLabel.text = String(nightList[indexPath.row].main!.temp!.toSelcius())
                imageView.image = UIImage(named: nightList[indexPath.row].weather![0].icon!)

            }
        } else {
            if checkImage.last == "d" {
                descriptionLabel.text = dayList[indexPath.row-1].weather![0].description
                tempLabel.text = String(dayList[indexPath.row-1].main!.temp!.toSelcius())
                imageView.image = UIImage(named: dayList[indexPath.row-1].weather![0].icon!)

                
                
            } else if checkImage.last == "n" {
                descriptionLabel.text = nightList[indexPath.row-1].weather![0].description
                tempLabel.text = String(nightList[indexPath.row-1].main!.temp!.toSelcius())
                imageView.image = UIImage(named: nightList[indexPath.row-1].weather![0].icon!)

                
                
            }
        }
        
        
    }
    
    
    
    // MARK: - Background View
    func setBlueGradientBackground(){
        backView.backgroundColor = UIColor(red: 1.0/255.0, green: 150.0/255.0, blue: 255.0, alpha: 1.0)
    }
    
    func setBlackGradientBackground(){
        backView.backgroundColor = UIColor.black
    }
    
}
