//
//  MovieListViewModel.swift
//  Movie
//
//  Created by Navneet on 4/25/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation

struct MovieListViewModel {
 
    let movie: String
    let results: Results?
    
    func loadPage(_ page: Int, completion: @escaping CompletionBlock) {
        guard let encodedQueryString = movie.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=\(encodedQueryString)&page=\(page)") else {
                return
        }
        
        let engine = NetworkEngine()
        engine.fetch(url, completion: completion)
    }
}
