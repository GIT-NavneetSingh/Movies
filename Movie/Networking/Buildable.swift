//
//  Buildable.swift
//  Movie
//
//  Created by Navneet on 5/1/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation

/**
 Types adopting the `Buildable` protocol can be used to build dictionary of parameters.
 */
public protocol Buildable {
    
    /// HTTP Method: GET
    var httpMethod: HTTPMethod { get }
    
    /// API Path for the request
    var urlString: String? { get }
}

public extension Buildable {

    var httpTimeout: HTTPTimeout {
        return .fifteen
    }
}

extension Buildable {
    
    /// Builds a URL Request object
    func build() -> URLRequest? {
        // Building the Request object
        guard let urlStr = urlString, let url = URL(string: urlStr) else { return nil }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = TimeInterval(httpTimeout.rawValue)
        return request
    }
}
