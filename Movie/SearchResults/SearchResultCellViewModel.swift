//
//  SearchResultCellViewModel.swift
//  Movie
//
//  Created by Navneet on 4/28/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation

struct SearchResultCellViewModel {
    let cache: NSCache<AnyObject, AnyObject>
    let title: String?
    let releaseDate: String?
    let overview: String?
    let posterPath: String?
    
    init(movie: Movie, cache: NSCache<AnyObject, AnyObject>) {
        title = movie.title
        releaseDate = movie.releaseDate
        overview = movie.overview
        posterPath = movie.posterPath
        self.cache = cache
    }

}
