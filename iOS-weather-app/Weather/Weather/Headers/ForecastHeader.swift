//
//  ForecastHeader.swift
//  Weather
//
//  Created by GEOLAB TRAININGS on 2/13/20.
//  Copyright © 2020 GEOLAB TRAININGS. All rights reserved.
//

import UIKit

class ForecastHeader: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(header title: String) {
        titleLabel.text = title.uppercased()
    }

}
