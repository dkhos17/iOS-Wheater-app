//
//  ForecastCell.swift
//  Weather
//
//  Created by GEOLAB TRAININGS on 2/6/20.
//  Copyright © 2020 GEOLAB TRAININGS. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {

    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var condition: UILabel!
    
    func configure(from model: ForecastModel) {
        self.icon.downloaded(from: model.iconURL)
        self.time.text = model.time
        self.condition.text = model.conditon
        self.temperature.text = model.temperature + "˚C"
    }
}
