//
//  Today.swift
//  Weather
//
//  Created by GEOLAB TRAININGS on 2/5/20.
//  Copyright © 2020 GEOLAB TRAININGS. All rights reserved.
//

import UIKit
import CoreLocation

class Today: UIViewController, CLLocationManagerDelegate, ErrorDelegate {
    
    // navbar part
    @IBOutlet weak var shareButton: UIButton!
    
    // up part
    @IBOutlet weak var wimage: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var weather: UILabel!
    
    // down up part
    @IBOutlet weak var constraint1: NSLayoutConstraint!
    @IBOutlet weak var constraint2: NSLayoutConstraint!
    @IBOutlet weak var constraint3: NSLayoutConstraint!
    @IBOutlet weak var constraint4: NSLayoutConstraint!
    @IBOutlet weak var constraint5: NSLayoutConstraint!
    
    // down down part
    @IBOutlet weak var cloud: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var direction: UILabel!
    
    @IBOutlet weak var UPView: UIView!
    @IBOutlet weak var DOWNView: UIView!
    @IBOutlet weak var DUPView: UIView!
    @IBOutlet weak var DDOWNView: UIView!
    
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var errorView: ErrorView!
    
    var locationManager = CLLocationManager()
    var load = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !load {
            showSpinner(onView: self.stackView)
        }
        configureConstraints()
    }
    
    func didReload(_ sender: Any) {
        hideError()
        refresh()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        refresh()
    }
    
    
    func configureConstraints() {
        let C1 = (1-3*0.2)*0.25*0.8; let C2 = 0.6*0.33*0.8;
        constraint1.constant = CGFloat(C1)*DOWNView.frame.width
        constraint2.constant = CGFloat(C1)*DOWNView.frame.width
        constraint3.constant = CGFloat(C1)*DOWNView.frame.width
        constraint4.constant = CGFloat(C2)*DOWNView.frame.width
        constraint5.constant = CGFloat(C2)*DOWNView.frame.width
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location as Any)
        self.locationManager.stopUpdatingLocation()
        refresh()
    }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        self.showError()
    }
    
    func loadWeatherForecast() throws {
        if let lon = locationManager.location?.coordinate.longitude, let lat = locationManager.location?.coordinate.latitude {
            let url = "https://api.openweathermap.org/data/2.5/weather?appid=b07da2abebb981b5b3874956763fa118&lat=\(lat)&lon=\(lon)"
            var request = URLRequest(url: URL(string: url)!)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"

            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration)
            let task = session.dataTask(with: request) { [weak self] (data, response, error) in
                guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                    self!.showError()
                    return
                }
                guard (200 ..< 300) ~= httpResponse.statusCode else {
                    self!.showError()
                    return
                }
                
                if var result = try? JSONDecoder().decode(TodayResult.self, from: data) {
                    let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
                    let iconURL = "https://openweathermap.org/img/wn/" + result.weather[0].icon + "@2x.png"
                    
                    result.configure()
                    DispatchQueue.main.async {
                        self!.setBackgroundColorBy(icon: result.weather[0].icon)
                        self!.setTextColorBy(icon: result.weather[0].icon)
                        self!.wimage.downloaded(from: iconURL)

                        self!.location.text = result.name + ", " + result.sys.country
                        self!.weather.text = String(result.main.temp) + "C˚ | " + result.weather[0].main
                        self!.cloud.text = String(result.clouds.all) + " %"
                        self!.humidity.text = String(result.main.humidity) + " mm"
                        self!.pressure.text = String(result.main.pressure) + " hPa"
                        self!.speed.text = String(result.wind.speed) + " km/h"

                        let idx = Int(result.wind.deg) & 7
                        self!.direction.text = directions[idx]
                        self!.load = true
                        self!.removeSpinner()
                    }
                }
            
            }
            task.resume()
        } else {
            showError()
        }
    }
    
    func setBackgroundColorBy(icon: String) {
        var color = UIColor.systemTeal
        if(icon.suffix(1) == "n") { // Night Color
            color = UIColor.black
        }
        
        self.UPView.backgroundColor = color
        self.DOWNView.backgroundColor = color
        self.DUPView.backgroundColor = color
        self.DDOWNView.backgroundColor = color
    }
    
    func setTextColorBy(icon: String) {
        var color = UIColor.white
        if(icon.suffix(1) == "n") { // Night color
            color = UIColor.systemPurple
        }
        
        self.location.textColor = color
        self.cloud.textColor = color
        self.humidity.textColor = color
        self.pressure.textColor = color
        self.speed.textColor = color
        self.direction.textColor = color
    }
    
    func showError() {
//        if(!self.ErrorView.isHidden) {return}
        DispatchQueue.main.async {
            self.errorView?.isHidden = false
            self.stackView?.isHidden = true
            self.shareButton?.isEnabled = false
            self.removeSpinner()
        }
    }
    
    func hideError() {
//        if(self.ErrorView.isHidden) {return}
        DispatchQueue.main.async {
            self.errorView?.isHidden = true
            self.stackView?.isHidden = false
            self.shareButton?.isEnabled = true
            self.removeSpinner()
        }
    }
    
    func configureShareText() -> String {
        let text = self.location.text! + " " + self.weather.text! + " " + self.cloud.text! + " " + self.humidity.text! + " " + self.pressure.text! + " " + self.speed.text! + " " + self.direction.text!
        return text
    }
    
    @IBAction func refresh(_ sender: UIButton? = nil) {
        sender?.isEnabled = false
        showSpinner(onView: self.stackView)
        do {
            try loadWeatherForecast()
        } catch {
            self.showError()
        }
        viewDidAppear(false)
        sender?.isEnabled = true
    }
    
    
    @IBAction func share() {
        let activityViewController = UIActivityViewController(activityItems: [configureShareText()], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
}
    




