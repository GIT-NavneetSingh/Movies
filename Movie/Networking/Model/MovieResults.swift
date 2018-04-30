//
//  MovieResults.swift
//  Movie
//
//  Created by Navneet on 4/25/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation

// MARK: - MovieResults, Movie to store results from the network reponse

public struct MovieResults: Codable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case movies = "results"
    }
}

struct Movie: Codable {
    let title: String?
    let overview: String?
    let releaseDate: String?
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
}
