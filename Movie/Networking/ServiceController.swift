//
//  ServiceController.swift
//  Movie
//
//  Created by Navneet on 4/25/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation
import UIKit

public typealias CompletionBlock = (_ results: MovieResults?, _ error: Error?) -> ()
public typealias DownloadBlock = (_ data: Data?) -> ()

protocol MoviesFetchable {
    func fetch(_ url: URL, completion: @escaping CompletionBlock)
}

protocol DataDownloadable {
    func download(_ url: URL, completion: @escaping DownloadBlock)
}

struct ServiceController: MoviesFetchable, DataDownloadable {
    
    func fetch(_ url: URL, completion: @escaping CompletionBlock) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            let results = try? JSONDecoder().decode(MovieResults.self, from: data)
            completion(results, error)
        }
        
        dataTask.resume()
    }
    
    func download(_ url: URL, completion: @escaping DownloadBlock) {
        let downloadTask = URLSession.shared.downloadTask(with: url) { (tempURL, response, error) in
            guard let url = tempURL else {
                completion(nil)
                return
            }
            
            completion(try? Data(contentsOf: url))
        }
        
        downloadTask.resume()
    }
}
