//
//  WeatherData+CoreDataProperties.swift
//  howissky
//
//  Created by Kamal Sharma on 31/01/21.
//  Copyright © 2021 Kamal Sharma. All rights reserved.
//
//

import Foundation
import CoreData


extension WeatherData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherData> {
        return NSFetchRequest<WeatherData>(entityName: "WeatherData")
    }

    @NSManaged public var cityID: Int32
    @NSManaged public var cityName: String?
    @NSManaged public var weatherResponse: Data?
}

