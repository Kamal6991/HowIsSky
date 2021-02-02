//
//  WeatherDataProvider.swift
//  howissky
//
//  Created by Kamal Sharma on 30/01/21.
//  Copyright © 2021 Kamal Sharma. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataOperationStatus {
    case success
    case failure
    case noResult
    case noAction
}
// MARK: - Data provider for weather with offline and online sources
class WeatherDataProvider {
    private let weatherDataEntity = "WeatherData"
    private let favoriteDataEntity = "FavoriteCity"
    private let defaultSelectedCityID: Int32 = 111

    // MARKS : - get weather info from API and if no internet then fetch from Core Data
    func getWeatherDataFor(_ cityName: String, completion: @escaping (WeatherRootResponse?, NetworkError?) -> Void) {
        fetchWeatherDataOnlineFor(cityName) { [weak self] (result, data) in
            guard let self = self else { return }
            switch result {
            case .success(let finalData):
                if finalData.statusCode == 200 {
                    self.updateDefaultWeatherDataOfflineFor(cityName: finalData.cityName ?? "", cityID: self.defaultSelectedCityID, data) { (isSuccess) in
                        print("entry save to core data")
                    }
                }
                DispatchQueue.main.async {
                    completion(finalData, nil)
                }

            case .failure(let error):
                switch error {
                case .noInternetError:
                    self.fetchDefaultWeatherDataInOfflineFor(cityName) { (status, data) in
                        switch status {
                        case .failure, .noAction, .noResult:
                            DispatchQueue.main.async {
                                completion(nil, .noInternetError)
                            }
                        case .success:
                            DispatchQueue.main.async {
                                completion(data, .noInternetError)
                            }
                        }
                    }
                default:
                    DispatchQueue.main.async {
                        completion(nil, error)                        
                    }
                    print("API Failure")
                }
            }
        }
    }
    // MARKS : - get weather info from Network Layer
    private func fetchWeatherDataOnlineFor(_ cityName: String, completion: @escaping (Result<WeatherRootResponse, NetworkError>, Data?) -> Void) {
        let networkManager = NetworkManager()
        var urlRequest = URLRequest(url: APIEndPoints.searchWeatherForCity(cityName).url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        networkManager.loadRequest(request: urlRequest, completion: completion)
    }
    // MARKS : - set default weather info for every call , only single element is store entire app
    private func fetchDefaultWeatherDataInOfflineFor(_ cityName: String, completion: @escaping (CoreDataOperationStatus, WeatherRootResponse?) -> Void) {
        let coreDataManager = CoreDataManager()
        coreDataManager.managedObjectMainQueueContext.perform {
            let request: NSFetchRequest<WeatherData> = NSFetchRequest(entityName: self.weatherDataEntity)
            let predicate = NSPredicate(format: "cityName == %@", cityName)
            request.predicate = predicate
            do {
                let dataResult = try coreDataManager.managedObjectMainQueueContext.fetch(request).first
                guard let responseData = dataResult?.weatherResponse else {
                    completion(.noResult, nil)
                    return
                }

                if let responseModel = try? JSONDecoder().decode(WeatherRootResponse.self, from: responseData){
                    completion(.success, responseModel)
                } else {
                    completion(.failure, nil)
                }
            } catch {
                completion(.failure, nil)
            }
        }
    }
    // MARKS : - Upadte/ insert existing weather data
    private func updateDefaultWeatherDataOfflineFor(cityName: String, cityID: Int32, _ data: Data?, completion: @escaping (CoreDataOperationStatus) -> Void) {
        let coreDataManager = CoreDataManager()
        coreDataManager.managedObjectPrivateQueueContext.perform {

            let request: NSFetchRequest<WeatherData> = NSFetchRequest(entityName: self.weatherDataEntity)
            let predicate = NSPredicate(format: "cityID == %i", self.defaultSelectedCityID)
            request.predicate = predicate
            var existingCity: WeatherData?

            do {
                existingCity = try coreDataManager.managedObjectPrivateQueueContext.fetch(request).first
            } catch {
                completion(.noResult)
                print("default city fetch error")
                return
            }

            if existingCity == nil {
                let entity = NSEntityDescription.insertNewObject(forEntityName: self.weatherDataEntity, into: coreDataManager.managedObjectPrivateQueueContext) as? WeatherData
                entity?.cityID = self.defaultSelectedCityID
                entity?.cityName = cityName.lowercased()
                entity?.weatherResponse = data
                completion(.success)
            } else {
                existingCity?.cityName = cityName
                existingCity?.weatherResponse = data
                completion(.success)
            }

            coreDataManager.saveContext()
        }
    }
    // MARKS : - fetch favorite List from core data
    func fetchFavoriteListFor(completion: @escaping (CoreDataOperationStatus, [FavoriteCity]?) -> Void) {
        let coreDataManager = CoreDataManager()
        coreDataManager.managedObjectMainQueueContext.perform {

            let request: NSFetchRequest<FavoriteCity> = FavoriteCity.fetchRequest()
            request.returnsObjectsAsFaults = true

            do {
                let favoriteList = try coreDataManager.managedObjectMainQueueContext.fetch(request)
                if !favoriteList.isEmpty {
                    completion(.success, favoriteList)
                } else {
                    completion(.noResult, [])
                }

            } catch {
                completion(.failure, nil)
                print("Deleting the city failed")
            }
        }
    }

    // MARKS : - Delete favorite from core data
    func deleteFavoriteFor(_ cityID: Int32, completion: @escaping (CoreDataOperationStatus) -> Void) {
        let coreDataManager = CoreDataManager()
        coreDataManager.managedObjectPrivateQueueContext.perform {

            let request: NSFetchRequest<FavoriteCity> = FavoriteCity.fetchRequest()
            let predicate = NSPredicate(format: "cityID == %i", cityID)
            request.predicate = predicate

            do {
                if let existingCity = try coreDataManager.managedObjectPrivateQueueContext.fetch(request).first {
                    coreDataManager.managedObjectPrivateQueueContext.delete(existingCity)
                    coreDataManager.saveContext()
                    completion(.success)
                    print("Deleting the city ")
                } else {
                    completion(.noAction)
                }
            } catch {
                completion(.failure)
                print("Deleting the city failed")
            }
        }
    }

    // MARKS : - add favorite to core data
    func addFavoriteFor(_ cityName: String, _ cityID: Int32, _ completion: @escaping (CoreDataOperationStatus) -> Void) {
        let coreDataManager = CoreDataManager()
        coreDataManager.managedObjectPrivateQueueContext.perform {

            let request: NSFetchRequest<FavoriteCity> = FavoriteCity.fetchRequest()
            let predicate = NSPredicate(format: "cityID == %i", cityID)
            request.predicate = predicate
            var existingCity: FavoriteCity?

            do {
                existingCity = try coreDataManager.managedObjectPrivateQueueContext.fetch(request).first
            } catch {
                completion(.noResult)
                print("default city fetch error")
                return
            }

            if existingCity == nil {
                let entity = NSEntityDescription.insertNewObject(forEntityName: self.favoriteDataEntity, into: coreDataManager.managedObjectPrivateQueueContext) as? FavoriteCity
                entity?.cityID = cityID
                entity?.cityName = cityName.lowercased()
                coreDataManager.saveContext()
                completion(.success)
            } else {
                completion(.noAction)
            }
        }
    }
}
