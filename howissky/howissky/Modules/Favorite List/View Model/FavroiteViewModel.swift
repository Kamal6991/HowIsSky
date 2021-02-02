//
//  FavroiteViewModel.swift
//  howissky
//
//  Created by Kamal Sharma on 02/02/21.
//  Copyright © 2021 Kamal Sharma. All rights reserved.
//

import Foundation
class FavroiteViewModel: NSObject {

    private let dataProvider = WeatherDataProvider()
    var uiRenderDataList: [(String?, Int32)]? = []

    // MARK: - Delete City From Offline Data
    func deleteThisFavroite(_ cityId: Int32?, completion: @escaping (Bool)-> Void) {
        guard let cityID = cityId else { return }
        dataProvider.deleteFavoriteFor(cityID) { (status) in
            DispatchQueue.main.async {
                if status == .success {
                    completion(true)
                } else {
                    //failure
                }
            }
        }
    }

    // MARK: - Fetch City From Offline Data
    func fetchFavroiteList(completion: @escaping (Bool)-> Void) {
        dataProvider.fetchFavoriteListFor { [weak self] (status, favroiteList) in
            guard let self = self else { return }
            guard let list = favroiteList else { return }

            self.uiRenderDataList?.removeAll()

            for model in list {
                self.uiRenderDataList?.append((model.cityName, model.cityID))
            }
            completion(true)
        }
    }
}
