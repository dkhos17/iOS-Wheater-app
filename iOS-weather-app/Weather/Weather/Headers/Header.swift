//
//  Header.swift
//  Weather
//
//  Created by GEOLAB TRAININGS on 2/13/20.
//  Copyright © 2020 GEOLAB TRAININGS. All rights reserved.
//

import UIKit

class Header: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(header title: String) {
        titleLabel.text = title
    }

}
