//
//  CellViewModel.swift
//  Movie
//
//  Created by Navneet on 4/28/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation

struct CellViewModel {
    
    let movie: Movie
    let cache: NSCache<AnyObject, AnyObject>
    
    func fetchImage(from path: String?, completion: @escaping DownloadBlock) {
        guard
            let path = path,
            let url = URL(string: "http://image.tmdb.org/t/p/w92\(path)") else {
                completion(nil)
                return
        }
        
        let engine = NetworkEngine()
        engine.download(url, completion: completion)
    }
}
