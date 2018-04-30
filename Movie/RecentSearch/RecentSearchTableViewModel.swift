//
//  RecentSearchTableViewModel.swift
//  Movie
//
//  Created by Navneet on 4/30/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation

private let MAX_ROWS = 10

struct RecentSearchTableViewModel {
    let items = UserDefaults.standard.array(forKey: "RecentSearchedMovies") as? [String]
    let maxRows = MAX_ROWS
}
