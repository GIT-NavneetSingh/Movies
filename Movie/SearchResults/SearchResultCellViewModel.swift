//
//  SearchResultCellViewModel.swift
//  Movie
//
//  Created by Navneet on 4/28/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation
import UIKit

// MARK: - View model for SearchResultsVC'table cell

struct SearchResultCellViewModel {
    let imageCache: NSCache<NSString, UIImage>?
    let title: String?
    let releaseDate: String?
    let overview: String?
    let posterPath: String?
    let defaultImage = #imageLiteral(resourceName: "default_image")
    var image: UIImage? = nil

    init(movie: Movie?, cache: NSCache<NSString, UIImage>?) {
        title = movie?.title
        releaseDate = movie?.releaseDate
        overview = movie?.overview
        posterPath = movie?.posterPath
        imageCache = cache

        if let path = posterPath as NSString?,
            let cachedImage = imageCache?.object(forKey: path) {
            image = cachedImage
        }
    }
    
    mutating func parseImageData(_ data: Data?) {
        guard let data = data, let image = UIImage(data: data), let path = posterPath else {
            self.image = #imageLiteral(resourceName: "default_image")
            return
        }
        
        self.image = image
        imageCache?.setObject(image, forKey: path as NSString)
    }
}
