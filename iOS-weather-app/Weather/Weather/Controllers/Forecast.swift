//
//  Forecast.swift
//  Weather
//
//  Created by GEOLAB TRAININGS on 2/5/20.
//  Copyright © 2020 GEOLAB TRAININGS. All rights reserved.
//

import UIKit
import CoreLocation

class Forecast: UIViewController, CLLocationManagerDelegate, ErrorDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var errorView: ErrorView!
    
    var locationManager = CLLocationManager()
    var currentlocation: CLLocation!
    
    var data: [SectionModel] = []
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
        registerViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !load {
            showSpinner(onView: self.tableView)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        refresh()
    }
    
    func didReload(_ sender: Any) {
        hideError()
        refresh()
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
    
    
    func load5DayWeatherForecast() throws {
        if let lon = locationManager.location?.coordinate.longitude, let lat = locationManager.location?.coordinate.latitude {
            let url = "https://api.openweathermap.org/data/2.5/forecast?appid=b07da2abebb981b5b3874956763fa118&lat=\(lat)&lon=\(lon)"
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
                
                if let result = try? JSONDecoder().decode(ForecastResult.self, from: data) {
                    var day = 0
                    self!.data = []
                    
                    for list in result.list {
                        let time = self!.getTimeBy(dt_txt: list.dt_txt)
                        let weekDay = self!.getDayBy(dt_txt: list.dt_txt)
                        let weekDayNum = self!.getDayNumBy(dt_txt: list.dt_txt)
                        let temperature = String(round(100*(list.main.temp-273.15))/100.0)
                        let description = list.weather[0].description
                        let iconURL = "https://openweathermap.org/img/wn/" + list.weather[0].icon + "@2x.png"
                        
                        if day != weekDayNum {
                            day = weekDayNum
                            self!.data.append(SectionModel(header: weekDay, cells: [ForecastModel]()))
                        }
                        self!.data[self!.data.count-1].cells.append(ForecastModel(iconURL: iconURL, time: time, conditon: description, temperature: temperature))
                    }
                    DispatchQueue.main.async {
                        self!.tableView?.reloadData()
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
    
    func getTimeBy(dt_txt dt: String) -> String {
        let start = dt.index(dt.startIndex, offsetBy: 11)
        let end = dt.index(dt.endIndex, offsetBy: -3)
        let range = start..<end
        return String(dt[range])
    }
    
    
    func getDayNumBy(dt_txt dt: String) -> Int {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: dt)
        return Calendar.current.component(.weekday, from: date!)
    }
    
    func getDayBy(dt_txt dt: String) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: dt)
        return df.weekdaySymbols[Calendar.current.component(.weekday, from: date!)-1]
    }
    
    
    
    
    @IBAction func refresh(_ sender: UIButton? = nil) {
        sender?.isEnabled = false
        showSpinner(onView: self.tableView)
        do {
            try load5DayWeatherForecast()
        } catch {
            self.showError()
        }
        sender?.isEnabled = true
    }
    
    
    func showError() {
        DispatchQueue.main.async {
            self.errorView?.isHidden = false
            self.tableView?.isHidden = true
            if(self.isActive()) {
                self.removeSpinner()
            }
        }
    }
    
    func hideError() {
        DispatchQueue.main.async {
            self.errorView?.isHidden = true
            self.tableView?.isHidden = false
            if(self.isActive()) {
                self.removeSpinner()
            }
        }
    }
    
   func registerViews() {
        tableView.register(
            UINib(nibName: "ForecastCell", bundle: nil),
            forCellReuseIdentifier: "ForecastCell"
        )
        tableView.register(
            UINib(nibName: "ForecastHeader", bundle: nil),
            forHeaderFooterViewReuseIdentifier: "ForecastHeader"
        )
    }
    
}

extension Forecast: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ForecastHeader") as! ForecastHeader
        header.configure(header: self.data[section].header)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastCell
        let model = data[indexPath.section].cells[indexPath.row]
        cell.configure(from: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
}
