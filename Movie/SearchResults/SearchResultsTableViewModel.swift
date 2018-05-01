//
//  SearchResultsTableViewModel.swift
//  Movie
//
//  Created by Navneet on 4/25/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation
import UIKit

// MARK: - View model for SearchResultsVC

struct SearchResultsTableViewModel {
    let movie: String?
    let title: String?
    var movies: [Movie]
    let totalPages: Int
    var currentPage: Int

    init(movie: String?, results: MovieResults) {
        self.movie = movie
        title = movie?.uppercased()
        movies = results.movies
        totalPages = results.totalPages
        currentPage = results.page
    }
    
    mutating func processMovieResults(_ movieResults: MovieResults?) {
        guard
            let results = movieResults,
            let newMovies = movieResults?.movies,
            !newMovies.isEmpty else {
                return
        }
        
        currentPage = results.page
        movies.append(contentsOf: newMovies)
    }
}
