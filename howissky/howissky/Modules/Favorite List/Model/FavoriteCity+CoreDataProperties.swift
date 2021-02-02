//
//  FavoriteCity+CoreDataProperties.swift
//  howissky
//
//  Created by Kamal Sharma on 31/01/21.
//  Copyright © 2021 Kamal Sharma. All rights reserved.
//
//

import Foundation
import CoreData


extension FavoriteCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCity> {
        return NSFetchRequest<FavoriteCity>(entityName: "FavoriteCity")
    }

    @NSManaged public var cityID: Int32
    @NSManaged public var cityName: String?

}
