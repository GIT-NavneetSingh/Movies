//
//  MovieListTableCellViewModel.swift
//  Movie
//
//  Created by Navneet on 4/28/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation

struct MovieListTableCellViewModel {
    
    let movie: Movie
    let cache: NSCache<AnyObject, AnyObject>
    
    init(movie: Movie, cache: NSCache<AnyObject, AnyObject>) {
        self.movie = movie
        self.cache = cache
    }
    
    lazy var engine = NetworkEngine()

    mutating func fetchImage(from path: String?, completion: @escaping DownloadBlock) {
        guard
            let path = path,
            let url = URL(string: "http://image.tmdb.org/t/p/w92\(path)") else {
                completion(nil)
                return
        }
        
        engine.download(url, completion: completion)
    }
}
