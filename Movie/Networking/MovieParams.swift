//
//  MovieParams.swift
//  Movie
//
//  Created by Navneet on 5/1/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation

struct MovieParams: Buildable {
    let query: String
    let page: Int
    
    private enum MovieConstants: String {
        case baseURL = "http://api.themoviedb.org/3/search/movie?"
        case apiKey = "2696829a81b1b5827d515ff121700838"
        
        var value: String {
            return rawValue
        }
    }
    
    var urlString: String? {
        guard let encodedString = query.urlEncodedString else {
            return nil
        }
        
        
        let baseURL = MovieConstants.baseURL.value + "api_key=\(MovieConstants.apiKey.value)"
        let urlStr = baseURL + "&query=\(encodedString)" + "&page=\(page)"
        return urlStr
    }
    
    var httpMethod: HTTPMethod {
        return .GET
    }
    
    var httpTimeout: HTTPTimeout {
        return .fifteen
    }
}
