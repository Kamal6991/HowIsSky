//
//  ViewController.swift
//  howissky
//
//  Created by Kamal Sharma on 29/01/21.
//  Copyright © 2021 Kamal Sharma. All rights reserved.
//

import UIKit

// MARK: - Show weather Details when called and user can search for city , add to favorites too.
class WeatherDetailViewController: UIViewController {

    lazy var viewModel = WeatherDetailViewModel()
    @IBOutlet weak var searchTextField: UITextField!

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var weatherTypeLabel: UILabel!

    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var feelLikeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    // MARK: - save city to favorite list offline
    @IBAction func addToFavorite(_ sender: UIButton) {
        viewModel.addToFavroite()
    }
    // MARK: - Move to favorite List page
    @IBAction func moveToFavoriteList(_ sender: UIButton) {
        guard let vc = UIStoryboard.load(.favroiteListViewController) as? FavroiteListViewController else {return}
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

extension WeatherDetailViewController: FavroiteListDelegate {
    // MARK: - favorite Selected call back
    func favoriteSelected(cityName: String) {
        fetchAnyLastDetailsForCity(cityName)
    }
}

extension WeatherDetailViewController {

    // MARK: - View init requered calls goes here
    private func initView() {
        setupSearchBar()
        fetchAnyLastDetailsForCity(searchTextField.text ?? "")
    }

    // MARK: - Search bar related goes here
    private func setupSearchBar() {
        searchTextField.delegate = self
    }

    // MARK: - Fetch city details from Online / Offline source
    private func fetchAnyLastDetailsForCity(_ name: String) {
        viewModel.fetchWeatherData(cityName: name.trimmingCharacters(in: .whitespacesAndNewlines)) { [weak self] (data, error)  in
            guard let self = self else { return }

            if let weatherDetails = data {
                self.feedDataToUI(weatherDetails)
            } else {
                switch error {
                case .badUrl:
                    print("not data")
                case .noInternetError:
                    self.showAlert("Alert", "Please enter city name")
                case .badAllErrorResponse(let code, _, _, _, _):
                    if code == 400 {
                        self.showAlert("Alert", "Please enter city name")
                    } else if code == 404 {
                        self.showAlert("City not Found!", "Please Check entered city name.")
                    }
                default:
                    print("__")
                }
            }
        }
    }

    // MARK: - Plot the Model data to respective UI elements
    private func feedDataToUI(_ data: WeatherRootResponse) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.cityNameLabel.text = data.cityName
            self.tempratureLabel.text = "\(Int(data.weatherDetails?.temp ?? 0.0))"
            self.minTempLabel.text = "Min Temp.: \(Int(data.weatherDetails?.tempMin ?? 0))"
            self.maxTempLabel.text = "Max Temp.: \(Int(data.weatherDetails?.tempMax ?? 0))"
        }
        self.windLabel.text = "Wind Speed : \(data.wind?.speed ?? 0.0)"
        self.pressureLabel.text = "Pressure : \(data.weatherDetails?.pressure ?? 0)"
        self.humidityLabel.text = "humidity : \(data.weatherDetails?.humidity ?? 0)"
        self.feelLikeLabel.text = "Feels Like : \(Int(data.weatherDetails?.feelsLike ?? 0.0))"

        guard let overView = data.weatherOverView?.first else {
            return
        }
        if let weatherName = overView.main {
            self.weatherTypeLabel.text = weatherName
        }
        if let iconName = overView.icon {
            UIImageView.loadImage(from: Configuration.getImageUrlFor(imageName: iconName)) { (image) in
                self.weatherIconImageView.image = image
            }
        }
    }

    // MARK: - Custom method for alert
    private func showAlert(_ title: String, _ msg: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    // MARK: - key board resign helper method
    private func resignkeyBoard() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.searchTextField.resignFirstResponder()
        }
    }
}

extension WeatherDetailViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty ?? false {
            let alert = UIAlertController(title: "Alert", message: "Please enter city name", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            fetchAnyLastDetailsForCity(textField.text ?? "")
        }
        resignkeyBoard()
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        resignkeyBoard()
        return true
    }
}
