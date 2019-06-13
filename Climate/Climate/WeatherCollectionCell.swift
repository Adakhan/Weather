//
//  WeatherCollectionCell.swift
//  Climate
//
//  Created by Adakhanau on 12/06/2019.
//  Copyright © 2019 Adakhan. All rights reserved.
//

import UIKit

class WeatherCollectionCell: UICollectionViewCell {
    
//    override var isSelected: Bool{
//        didSet{
//            if self.isSelected
//            {
//                
//            }
//            else
//            {
//                //This block will be executed whenever the cell’s selection state is set to false (i.e For the rest of the cells)
//            }
//        }
//    }
    
    
    @IBOutlet weak var weekdayLabel: UILabel!
    
    @IBOutlet weak var dayTempLabel: UILabel!
    @IBOutlet weak var nightTempLabel: UILabel!
    
}
