//
//  ExpandHeader.swift
//  Weather
//
//  Created by GEOLAB TRAININGS on 2/6/20.
//  Copyright © 2020 GEOLAB TRAININGS. All rights reserved.
//

import UIKit

protocol ExpandHeaderDelegate: AnyObject {
    func expandHeader(_ sender: ExpandHeader, didClickExpandAt section: Int)
}

class ExpandHeader: UITableViewHeaderFooterView {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    
    var model: ExpandHeaderModel!
    
    func configure(from model: ExpandHeaderModel) {
        self.model = model
        titleLabel.text = model.title
        let buttonTitle = model.isExpanded ? "Collapse" : "Expand"
        expandButton.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func handleExpand(_ sender: Any) {
        model.delegate?.expandHeader(self, didClickExpandAt: model.section)
    }
}
