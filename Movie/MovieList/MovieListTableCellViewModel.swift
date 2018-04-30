//
//  MovieListTableCellViewModel.swift
//  Movie
//
//  Created by Navneet on 4/28/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation

struct MovieListTableCellViewModel {
    let movie: Movie?
    let cache: NSCache<AnyObject, AnyObject>
}
