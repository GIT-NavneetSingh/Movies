//
//  SearchResultsViewModel.swift
//  Movie
//
//  Created by Navneet on 4/25/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation

struct SearchResultsViewModel {
    let movie: String?
    let title: String?
    let movies: [Movie]?
    let totalPages: Int?

    init(movie: String?, results: MovieResults?) {
        self.movie = movie
        title = movie?.uppercased()
        movies = results?.movies
        totalPages = results?.totalPages
    }
}
