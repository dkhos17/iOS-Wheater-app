//
//  ErrorViewHandler.swift
//  Weather
//
//  Created by GEOLAB TRAININGS on 2/13/20.
//  Copyright © 2020 GEOLAB TRAININGS. All rights reserved.
//

import UIKit

class ErrorViewHandler: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var Reload: UIButton!
    
    var delegate: ErrorDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let bundle = Bundle.main
        bundle.loadNibNamed(className, owner: self, options: nil)
        
        guard let content = contentView else {
            fatalError("contentView Not Set")
        }
        
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(content)
    }
    
    @IBAction func handleReload(_ sender: Any) {
        delegate?.didReload(sender)
    }
    
    
    
}

protocol ErrorDelegate {
    func didReload(_ sender: Any)
}

