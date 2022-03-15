//
//  Movie+CoreDataClass.swift
//  RentaTeamTest
//
//  Created by Azat Battalov on 14.03.2022.
//
//

import Foundation
import CoreData

@objc (Movie)
public class Movie: NSManagedObject {

    static let BASE_POSTER_URL = "https://image.tmdb.org/t/p/";
    static let SMALL_POSTER_SIZE = "w185";
    static let BIG_POSTER_SIZE = "w342";
    
    class func newMoview (dict: [String: Any]){
        let movie = Movie(context: CoreDataManager.sharedInstance.managedObjectContext)
        movie.id = (dict["id"] as! NSNumber).int16Value
        movie.title = dict["title"] as? String ?? "empty title"
        movie.voteAverage = dict["vote_average"] as! Double
        movie.voteCount = (dict["vote_count"] as! NSNumber).int32Value
        let posterPath = dict["poster_path"] as? String ?? ""
        movie.smallImage = BASE_POSTER_URL + SMALL_POSTER_SIZE + posterPath
        movie.largeImage = BASE_POSTER_URL + BIG_POSTER_SIZE + posterPath
        CoreDataManager.sharedInstance.saveContext()
    }
}
