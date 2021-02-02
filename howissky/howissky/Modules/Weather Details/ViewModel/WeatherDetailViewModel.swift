//
//  WeatherDetailViewModel.swift
//  howissky
//
//  Created by Kamal Sharma on 30/01/21.
//  Copyright © 2021 Kamal Sharma. All rights reserved.
//

import Foundation

class WeatherDetailViewModel: NSObject {
    private let dataProvider = WeatherDataProvider()
    private var currentRootResponse: WeatherRootResponse?

    // MARK: - fetch city data from API or Last searched city if no internet
    public func fetchWeatherData(cityName: String, completion: @escaping (WeatherRootResponse?, NetworkError?) -> Void) {
        dataProvider.getWeatherDataFor(cityName) { [weak self] (response , error)  in
            guard let self = self else { return }
            if let data = response {
                self.currentRootResponse = data
                completion(data, error)
            } else {
                completion(response, error)
            }
        }
    }

    // MARK: - Helper method to add favorites citys to offline storage
    func addToFavroite(){
        guard let cityName = currentRootResponse?.cityName else { return }
        guard let cityID = currentRootResponse?.cityID else { return }
        dataProvider.addFavoriteFor(cityName, cityID) { (status) in

        }
    }
}


