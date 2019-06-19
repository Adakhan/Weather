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
    
    
    //MARK: - Update Data
    func UpdateCurrentData(information: CurrentWeather){
        self.weekDayLabel.text = information.dt?.toWeekday(0)
        
        self.checkImage = (information.weather?[0].icon)!
        self.collecView.reloadData()
        
        if checkImage.last! == "d" {
            self.setBlueGradientBackground()
        } else {
            self.setBlackGradientBackground()
        }
    }
    
    func UpdateForecastData(informations: DetailedWeather){
        self.cityLabel?.text = informations.city!.name!.translate()
        self.dtTime = informations.list![0].dt!
    
        for checked in informations.list! {
            if checked.dt_txt!.suffix(8) == "09:00:00" {
                self.dayList.append(checked)
            } else if checked.dt_txt!.suffix(8) == "21:00:00" {
                self.nightList.append(checked)
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
        
        cell.weekdayLabel.text = dtTime.toWeekday(indexPath.row)
        cell.dayTempLabel.text = dayList[indexPath.row].main!.temp!.toSelcius()
        cell.nightTempLabel.text = nightList[indexPath.row].main!.temp!.toSelcius()
        
        //MARK: - UI Update
        loadMainUI()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        weekDayLabel.text = dtTime.toWeekday(indexPath.row)
        
        if checkImage.last == "d" {
            descriptionLabel.text = dayList[indexPath.row].weather![0].description?.translate()
            tempLabel.text = dayList[indexPath.row].main!.temp!.toSelcius()
            imageView.image = UIImage(named: dayList[indexPath.row].weather![0].icon!)
            
        } else if checkImage.last == "n" {
            descriptionLabel.text = nightList[indexPath.row].weather![0].description?.translate()
            tempLabel.text = nightList[indexPath.row].main!.temp!.toSelcius()
            imageView.image = UIImage(named: nightList[indexPath.row].weather![0].icon!)
        }
    }
    
    // Change UI
    func loadMainUI() {
        if checkImage.last == "d" {
            self.tempLabel.text = dayList[0].main!.temp!.toSelcius()
            self.descriptionLabel.text = dayList[0].weather![0].description!.translate()
            self.imageView.image = UIImage(named: (dayList[0].weather?[0].icon!)!)
            
            
        } else if checkImage.last == "n" {
            self.imageView.image = UIImage(named: (nightList[0].weather?[0].icon!)!)
            self.tempLabel.text = nightList[0].main!.temp!.toSelcius()
            self.descriptionLabel.text = nightList[0].weather![0].description!.translate()
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
