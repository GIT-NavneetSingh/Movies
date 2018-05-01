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
    
    private enum PosterImageConstants: String {
        case baseURL = "http://image.tmdb.org/t/p/w92"
        
        var value: String {
            return rawValue
        }
    }
    
    var urlString: String? {
        guard let encodedPath = path.urlEncodedString else {
            return nil
        }
        
        return PosterImageConstants.baseURL.value + "\(encodedPath)"
    }
    
    var httpMethod: HTTPMethod {
        return .GET
    }
    
    var httpTimeout: HTTPTimeout {
        return .thirty
    }
}
