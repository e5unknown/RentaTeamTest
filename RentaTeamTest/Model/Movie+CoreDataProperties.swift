//
//  Movie+CoreDataProperties.swift
//  RentaTeamTest
//
//  Created by Azat Battalov on 15.03.2022.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var id: Int16
    @NSManaged public var largeImage: String?
    @NSManaged public var smallImage: String?
    @NSManaged public var title: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int32

}
