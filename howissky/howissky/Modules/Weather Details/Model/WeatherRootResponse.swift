//
//  WeatherRootResponse.swift
//  howissky
//
//  Created by Kamal Sharma on 30/01/21.
//  Copyright © 2021 Kamal Sharma. All rights reserved.
//

//import Foundation
//
//// MARK: - RootReponse
//struct WeatherRootResponse: Codable {
//    var statusCode: String?
//    var message: Int?
//    var count: Int?
//    var list: [List]?
//    var city: City?
//
//    enum CodingKeys: String, CodingKey {
//        case statusCode = "cod"
//        case message = "message"
//        case count = "cnt"
//        case list = "list"
//        case city = "city"
//    }
//}
//
//// MARK: - City
//struct City: Codable {
//    var cityId: Int32?
//    var name: String?
//    var coord: Coord?
//    var country: String?
//    var population: Int?
//    var timezone: Int?
//    var sunrise: Int?
//    var sunset: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case cityId = "id"
//        case name = "name"
//        case coord = "coord"
//        case country = "country"
//        case population = "population"
//        case timezone = "timezone"
//        case sunrise = "sunrise"
//        case sunset = "sunset"
//    }
//}
//
//// MARK: - Coord
//struct Coord: Codable {
//    var lat: Double?
//    var lon: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case lat = "lat"
//        case lon = "lon"
//    }
//}
//
//// MARK: - List
//struct List: Codable {
//    var dt: Int?
//    var main: DetailInfo?
//    var weather: [Weather]?
//    var clouds: Clouds?
//    var wind: Wind?
//    var visibility: Int?
//    var pop: Double?
//    var sys: Sys?
//    var dtTxt: String?
//    var rain: Rain?
//    var date: String? {
//        guard let index = dtTxt?.lastIndex(of: " ") else { return "" }
//        return String((dtTxt ?? "")[..<index])
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case dt = "dt"
//        case main = "main"
//        case weather = "weather"
//        case clouds = "clouds"
//        case wind = "wind"
//        case visibility = "visibility"
//        case pop = "pop"
//        case sys = "sys"
//        case dtTxt = "dt_txt"
//        case rain = "rain"
//    }
//}
//
//// MARK: - Clouds
//struct Clouds: Codable {
//    var all: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case all = "all"
//    }
//}
//
//// MARK: - MainClass
//struct DetailInfo: Codable {
//    var temp: Double?
//    var feelsLike: Double?
//    var tempMin: Double?
//    var tempMax: Double?
//    var pressure: Int?
//    var seaLevel: Int?
//    var grndLevel: Int?
//    var humidity: Int?
//    var tempKf: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case temp = "temp"
//        case feelsLike = "feels_like"
//        case tempMin = "temp_min"
//        case tempMax = "temp_max"
//        case pressure = "pressure"
//        case seaLevel = "sea_level"
//        case grndLevel = "grnd_level"
//        case humidity = "humidity"
//        case tempKf = "temp_kf"
//    }
//}
//
//// MARK: - Rain
//struct Rain: Codable {
//    var the3H: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case the3H = "3h"
//    }
//}
//
//// MARK: - Sys
//struct Sys: Codable {
//    var pod: Pod?
//
//    enum CodingKeys: String, CodingKey {
//        case pod = "pod"
//    }
//}
//
//enum Pod: String, Codable {
//    case day = "d"
//    case night = "n"
//}
//
//// MARK: - Weather
//struct Weather: Codable {
//    var id: Int?
//    var mainWeather: String?
//    var weatherDescription: String?
//    var icon: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case mainWeather = "main"
//        case weatherDescription = "description"
//        case icon = "icon"
//    }
//}
//
//// MARK: - Wind
//struct Wind: Codable {
//    var speed: Double?
//    var deg: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case speed = "speed"
//        case deg = "deg"
//    }
//}

import Foundation

// MARK: - RootReponse
struct WeatherRootResponse: Codable {

    var weatherOverView: [WeatherOverView]?
    var weatherDetails: WeatherDetailInfo?
    var visibility: Int?
    var wind: Wind?
    var date: Int32?
    var countryInfo: CountryInfo?
    var timezone: Int?
    var cityID: Int32?
    var cityName: String?
    var statusCode: Int?

    enum CodingKeys: String, CodingKey {
        case weatherOverView = "weather"
        case weatherDetails = "main"
        case visibility = "visibility"
        case wind = "wind"
        case date = "dt"
        case countryInfo = "sys"
        case timezone = "timezone"
        case cityID = "id"
        case cityName = "name"
        case statusCode = "cod"
    }
}

// MARK: - Main
struct WeatherDetailInfo: Codable {
    var temp: Double?
    var feelsLike: Double?
    var tempMin: Double?
    var tempMax: Double?
    var pressure: Double?
    var humidity: Double?

    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
    }
}

// MARK: - Sys
struct CountryInfo: Codable {
    var type: Int?
    var uniqueID: Int?
    var country: String?
    var sunrise: Int?
    var sunset: Int?

    enum CodingKeys: String, CodingKey {
        case type = "type"
        case uniqueID = "id"
        case country = "country"
        case sunrise = "sunrise"
        case sunset = "sunset"
    }
}

// MARK: - Weather
struct WeatherOverView: Codable {
    var weatherID: Int?
    var main: String?
    var weatherDescription: String?
    var icon: String?

    enum CodingKeys: String, CodingKey {
        case weatherID = "id"
        case main = "main"
        case weatherDescription = "description"
        case icon = "icon"
    }
}

// MARK: - Wind
struct Wind: Codable {
    var speed: Double?
    var degree: Int?

    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case degree = "deg"
    }
}
