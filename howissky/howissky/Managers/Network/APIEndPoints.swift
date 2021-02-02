//
//  APIEndPoints.swift
//  howissky
//
//  Created by Kamal Sharma on 29/01/21.
//  Copyright © 2021 Kamal Sharma. All rights reserved.
//

import Foundation


enum APIEndPoints {

    private enum Units: String {
        case metric
        case imperial
    }

    private enum QueryParameterKey: String {
        case units
        case appid
        case count = "cnt"
    }

    private var unitQuery: String {
        "&\(QueryParameterKey.units)=\(Units.metric)"
    }

    private var countQuery: String {
        "&\(QueryParameterKey.count.rawValue)=40"
    }

    case searchWeatherForCity(String)

    var url: URL {
        var urlString = Configuration.baseUrl

        switch self {
        case .searchWeatherForCity(let name):
            urlString.append("weather?q=\(name)\(unitQuery)\(countQuery)")
        }

        urlString.append("&\(QueryParameterKey.appid)=\(Configuration.ApiKey)")
        return URL(string: urlString)!
    }

}

class Configuration {
    static let baseUrl = "http://api.openweathermap.org/data/2.5/"
    static let ApiKey = "7ef4d67d9ccf192de4b6cc0c92ac5f0c"
    static let imageBaseUrl = "http://openweathermap.org/img/wn/"

    static func getImageUrlFor(imageName: String) -> String {
        return "\(imageBaseUrl)\(imageName)@2x.png"
    }
}
