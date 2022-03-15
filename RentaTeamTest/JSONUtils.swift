//
//  JSONUtil.swift
//  RentaTeam Test
//
//  Created by Azat Battalov on 14.03.2022.
//

import Foundation

public class JSONUtil{
    
    
    static func parseMoviesDataFromResponse(response: Data) -> [[String: Any]]{
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: response, options: .mutableLeaves)
            if let jsonResult = jsonResult as? [String: Any],
               let results = jsonResult["results"] as? [[String:Any]] {
                return results
            } else{
                print("Error converting format data from server")
            }
        } catch let error{
            print("Error parsing data from server", error.localizedDescription)
        }
        
        return []
    }
}
