//
//  SearchViewModel.swift
//  Movie
//
//  Created by Navneet on 4/30/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation

struct SearchViewModel: NetworkEngine {
    
    let title: String?
    
    func fetchResults(_ queryString: String?, completion: @escaping CompletionBlock) {
        guard
            let queryString = queryString,
            let encodedQueryString = queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=\(encodedQueryString)&page=1")
            else { return }
            
        fetch(url, completion: completion)
    }
}
