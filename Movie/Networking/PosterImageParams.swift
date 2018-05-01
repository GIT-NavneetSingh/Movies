//
//  PosterImageParams.swift
//  Movie
//
//  Created by Navneet on 5/1/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation

struct PosterImageParams: Buildable {
    let path: String
    
    var urlString: String? {
        guard let encodedPath = path.urlEncodedString else {
            return nil
        }
        
        let baseURL = "http://image.tmdb.org/t/p/w92"
        let urlStr = baseURL + "\(encodedPath)"
        return urlStr
    }
    
    var httpMethod: HTTPMethod {
        return .GET
    }
    
    var httpTimeout: HTTPTimeout {
        return .thirty
    }
}
