//
//  ServerManager.swift
//  Climate
//
//  Created by Adakhanau on 13/06/2019.
//  Copyright © 2019 Adakhan. All rights reserved.
//

import Foundation
import Alamofire

class ServerManager {
    
    static let shared = ServerManager()
    
    private let main = "http://api.openweathermap.org/data/2.5/"
    private let coord = "lat=42.874722&lon=74.612222"
    private let key = "079587841f01c6b277a82c1c7788a6c3"
    
    
    func loadCurrentWeather( completion: @escaping (CurrentWeather)->() ) {
        
        let jsonUrlString = "\(main)weather?\(coord)&APPID=\(key)"
        
        guard let url = URL(string: jsonUrlString) else { return }
        
        Alamofire.request(url).validate().responseJSON { (response) in
            let result = response.data
    
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let information = try decoder.decode(CurrentWeather.self, from: result!)
                
                DispatchQueue.main.async {
                    completion(information)
                }
            }  catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
        }
        
    }
    
    func loadForecastWeather( completion:  @escaping (DetailedWeather)->()){
        
        let jsonUrlString = "\(main)forecast?\(coord)&APPID=\(key)"
        
        guard let url = URL(string: jsonUrlString) else { return }
        
        Alamofire.request(url).validate().responseJSON { (response) in
            let result = response.data
            
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let informations = try decoder.decode(DetailedWeather.self, from: result!)
                
                DispatchQueue.main.async {
                    completion(informations)
                }
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
        }

    }
}
