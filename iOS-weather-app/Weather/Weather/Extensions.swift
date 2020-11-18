//
//  Extensions.swift
//  Weather
//
//  Created by GEOLAB TRAININGS on 2/10/20.
//  Copyright © 2020 GEOLAB TRAININGS. All rights reserved.
//

import UIKit

var vSpinner : UIView?
var blurEffectView: UIVisualEffectView?

extension UIViewController {
    func showSpinner(onView : UIView?) {
        if(onView == nil || isActive()) { return }
        let spinnerView = UIView.init(frame: onView!.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.6)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView!.frame = onView!.bounds
        blurEffectView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        onView!.addSubview(blurEffectView!)
        
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView!.addSubview(spinnerView)
        }
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            blurEffectView?.removeFromSuperview()
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
    
    func isActive() -> Bool {
        return vSpinner != nil
    }
    
}


extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    DispatchQueue.main.async() {
                        self.image = UIImage(contentsOfFile: "cloud")
                    }
                    return
            }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


extension NSObject {
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
