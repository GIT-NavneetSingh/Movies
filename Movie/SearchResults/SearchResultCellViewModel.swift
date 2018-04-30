//
//  SearchResultCellViewModel.swift
//  Movie
//
//  Created by Navneet on 4/28/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation
import UIKit

struct SearchResultCellViewModel {
    let cache: NSCache<AnyObject, AnyObject>
    let title: String?
    let releaseDate: String?
    let overview: String?
    let posterPath: String?
    let defaultImage = #imageLiteral(resourceName: "default_image")
    var image: UIImage? = nil

    init(movie: Movie?, cache: NSCache<AnyObject, AnyObject>) {
        title = movie?.title
        releaseDate = movie?.releaseDate
        overview = movie?.overview
        posterPath = movie?.posterPath
        self.cache = cache

        if let cachedData = cache.object(forKey: posterPath as AnyObject) as? Data {
            image = UIImage(data: cachedData)
        }
    }
    
    mutating func parseImageData(_ data: Data?) {
        guard let data = data, let image = UIImage(data: data), let path = posterPath else {
            self.image = #imageLiteral(resourceName: "default_image")
            return
        }
        
        self.image = image
        cache.setObject(data as AnyObject, forKey: path as AnyObject)
    }
}
