//
//  ServiceController.swift
//  Movie
//
//  Created by Navneet on 4/25/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation
import UIKit

typealias CompletionBlock = ((_ results: MovieResults?, _ error: Error?) -> ())?
typealias DownloadBlock = ((_ image: UIImage?, _ error: Error?) -> ())?

protocol Fetchable {
    func fetch(with params: Buildable, completion: CompletionBlock)
    func download(with params: Buildable, completion: DownloadBlock)
}

// MARK: - ServiceController to handle netwoking
struct ServiceController: Fetchable {
    
    // MARK: - Fetch movie list
    func fetch(with params: Buildable, completion: CompletionBlock) {
        guard let request = params.build() else {
            completion?(nil, nil)
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard error == nil, let data = data else {
                completion?(nil, error)
                return
            }
            
            let results = try? JSONDecoder().decode(MovieResults.self, from: data)
            completion?(results, error)
        })
        
        dataTask.resume()

    }

    // MARK: - Download image of a movie
    func download(with params: Buildable, completion: DownloadBlock) {
        guard let request = params.build() else {
            completion?(nil, nil)
            return
        }
        
        let downloadTask = URLSession.shared.downloadTask(with: request, completionHandler: { (tempURL, response, error) in
            guard error == nil, let url = tempURL, let data = try? Data(contentsOf: url) else {
                completion?(nil, error)
                return
            }
        
            completion?(UIImage(data: data), nil)
        })

        downloadTask.resume()
    }
}

extension String {
    var urlEncodedString: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
