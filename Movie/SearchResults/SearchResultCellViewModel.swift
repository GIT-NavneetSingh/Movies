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

    var serviceController: DataDownloadable = ServiceController()

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
    
    func getImage(_ completion: @escaping (_ image: UIImage) -> ()) {
        guard let path = posterPath else {
            completion(defaultImage)
            return
        }

        serviceController.downloadImage(from: path) { data in
            guard let data = data, let image = UIImage(data: data) else {
                completion(self.defaultImage)
                return
            }
            
            self.imageCache?.setObject(image, forKey: path as NSString)

            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
