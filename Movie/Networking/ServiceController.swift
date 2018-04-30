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
typealias DownloadBlock = ((_ data: Data?) -> ())?

protocol MoviesFetchable {
    func fetch(for movie: String, page: Int, completion: CompletionBlock)
}

protocol DataDownloadable {
    func downloadImage(from path: String, completion: DownloadBlock)
}

// MARK: - ServiceController to handle netwoking
struct ServiceController: MoviesFetchable, DataDownloadable {
    
    // MARK: -
    private enum URLValue {
        case movie(query: String, page: Int)
        case image(path: String)
        
        var url: URL? {
            switch self {
            case .movie(let query, let page):
                let baseURL = "http://api.themoviedb.org/3/search/movie?"
                let apiKey = "api_key=2696829a81b1b5827d515ff121700838"
                let urlStr = baseURL + apiKey + "&query=\(query)" + "&page=\(page)"
                return URL(string: urlStr)
                
            case .image(let path):
                let baseURL = "http://image.tmdb.org/t/p/w92"
                let urlStr = baseURL + "\(path)"
                return URL(string: urlStr)
            }
        }
    }
    
    // MARK: - Fetch movie list
    
    func fetch(for movie: String, page: Int, completion: CompletionBlock) {
        guard
            let encodedString = movie.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URLValue.movie(query: encodedString, page: page).url
            else {
                completion?(nil, nil)
                return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else {
                completion?(nil, error)
                return
            }
            
            let results = try? JSONDecoder().decode(MovieResults.self, from: data)
            completion?(results, error)
        }
        
        dataTask.resume()
    }
    
    // MARK: - Download image of a movie
    
    func downloadImage(from path: String, completion: DownloadBlock) {
        guard
            let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URLValue.image(path: encodedPath).url else {
                completion?(nil)
                return
        }
        
        let downloadTask = URLSession.shared.downloadTask(with: url) { (tempURL, response, error) in
            guard let url = tempURL else {
                completion?(nil)
                return
            }
            
            completion?(try? Data(contentsOf: url))
        }
        
        downloadTask.resume()
    }
}
