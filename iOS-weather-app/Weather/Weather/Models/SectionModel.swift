//
//  SectionModel.swift
//  Weather
//
//  Created by GEOLAB TRAININGS on 2/11/20.
//  Copyright © 2020 GEOLAB TRAININGS. All rights reserved.
//

import UIKit

struct SectionModel {
    var header: String
    var cells = [ForecastModel]()
    
    var numberOfRows: Int {
        return cells.count
    }
}
