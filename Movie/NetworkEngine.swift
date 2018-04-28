//
//  NetworkEngine.swift
//  Movie
//
//  Created by Navneet on 4/25/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation
import UIKit

public typealias CompletionBlock = (_ results: Results?, _ error: Error?) -> ()
public typealias DownloadBlock = (_ data: Data?) -> ()

class NetworkEngine {
    
    func fetch(_ url: URL, completion: @escaping CompletionBlock) {
        print(url.absoluteString)
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
