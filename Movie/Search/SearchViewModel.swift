//
//  SearchViewModel.swift
//  Movie
//
//  Created by Navneet on 5/1/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation

struct SearchViewModel {
    
    let title = "Search"
    var searchQuery = ""

    // MARK: - Persist Searches
    
    mutating func persistSearchQuery(_ query: String?) {
        guard let query = query?.lowercased() else { return }
        
        searchQuery = query
        
        let userDefault = UserDefaults.standard
        if var list = userDefault.array(forKey: "RecentSearchedMovies") as? [String] {
            if let index = list.index(of: query) {
                list.remove(at: index)
            }
            
            list.insert(query, at: 0)
            userDefault.set(list, forKey: "RecentSearchedMovies")
        } else {
            userDefault.set([query], forKey: "RecentSearchedMovies")
        }

        userDefault.synchronize()
    }
}
