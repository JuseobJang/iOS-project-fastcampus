//
//  ViewController.swift
//  WeatherApp
//
//  Created by seob_jj on 2021/10/14.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weaherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var weatherStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    

    @IBAction func fetchWeatherButtonTapped(_ sender: UIButton) {
        if let cityName = self.cityTextField.text {
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true)
        }
    }
    
    func configurationView(weatherInfo: WeatherInfo){
        self.cityLabel.text = weatherInfo.name
        if let weather = weatherInfo.weather.first {
            self.weaherDescriptionLabel.text = weather.description
        }
        self.tempLabel.text = "\(Int(weatherInfo.temp.temp - 273.15))℃"
        self.minTempLabel.text = "최저: \(Int(weatherInfo.temp.minTemp - 273.15))℃"
        self.maxTempLabel.text = "최고: \(Int(weatherInfo.temp.maxTemp - 273.15))℃"
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert,animated: true)
    }
    
    func getCurrentWeather(cityName: String){
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=9ed9a56f2a23c14f0a2c74fbeef94dc3") else { return }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { [weak self] data, response, error in
            let successRange = (200..<300)
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let weatherInfo = try? decoder.decode(WeatherInfo.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false
                    self?.configurationView(weatherInfo: weatherInfo)
                }
            } else {
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
        }.resume()
    }
    
}

