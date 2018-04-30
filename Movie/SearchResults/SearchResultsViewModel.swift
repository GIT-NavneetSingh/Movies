//
//  SearchResultsViewModel.swift
//  Movie
//
//  Created by Navneet on 4/25/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation
import UIKit

// MARK: - View model for SearchResultsVC

struct SearchResultsViewModel {
    let movie: String?
    let title: String?
    var movies: [Movie]?
    let totalPages: Int?
    
    let cache = NSCache<NSString, UIImage>()

    init(movie: String?, results: MovieResults?) {
        self.movie = movie
        title = movie?.uppercased()
        movies = results?.movies
        totalPages = results?.totalPages
    }
    
    mutating func appendMovieResults(_ newMovies: [Movie]) {
        movies?.append(contentsOf: newMovies)
    }
    
    func removeAllCachedImages() {
        cache.removeAllObjects()
    }
}
