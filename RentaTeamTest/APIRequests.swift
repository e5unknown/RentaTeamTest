//
//  APIRequests.swift
//  RentaTeam Test
//
//  Created by Azat Battalov on 14.03.2022.
//

import Foundation

public class APIRequests{
    
    static let PARAM_API_KEY = "api_key"
    static let PARAM_LANGUAGE = "language"
    static let PARAM_SORT_BY = "sort_by"
    static let PARAM_PAGE = "page"
    static let PARAM_MIN_VOTE_COUNT = "vote_count.gte";
    
    static let baseUrl = "https://api.themoviedb.org/3/discover/movie"
    static let private_key = "69bfd8697567a8053a359ae8d29a6809"
    static let lang = "ru-RU"
    static let sortByPopularity = "vote_count.desc"
    static let minVotesCount = "1000"
    
    //Запрос БД постеров с сайта
    static func fetchMoviesData(page: Int, completion: @escaping (Data?, Error?) -> Void){
        //собрать URL запрос
        let url = buildURLRequest(page:page)
        print(url)
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                print(data.description)
                completion(data, nil)
            }
            if let error = error {
                completion(nil, error)
            }
        }.resume()
        
    }
    
    static private func buildURLRequest(page:Int) -> URL{
        var urlComponents = URLComponents(string: baseUrl)!
        let queryItems = [URLQueryItem(name: PARAM_API_KEY, value: private_key), URLQueryItem(name: PARAM_LANGUAGE, value: lang), URLQueryItem(name: PARAM_SORT_BY, value: sortByPopularity),URLQueryItem(name: PARAM_MIN_VOTE_COUNT, value: minVotesCount), URLQueryItem(name: PARAM_PAGE, value: page.description)]
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}
