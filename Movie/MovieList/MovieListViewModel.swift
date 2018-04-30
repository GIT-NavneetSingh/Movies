//
//  MovieListViewModel.swift
//  Movie
//
//  Created by Navneet on 4/25/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation

struct MovieListViewServiceHanlder: NetworkEngine {
    
    func fetch(_ url: URL, completion: @escaping CompletionBlock) {
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            let results = try? JSONDecoder().decode(Results.self, from: data)
            completion(results, error)
        }
        
        dataTask.resume()
    }
}

struct MovieListViewModel {
    let movie: String?
    let results: Results?
}
