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

protocol NetworkEngine {
    func fetch(_ url: URL, completion: @escaping CompletionBlock)
    func download(_ url: URL, completion: @escaping DownloadBlock)
}

extension NetworkEngine {
    
    func fetch(_ url: URL, completion: @escaping CompletionBlock) {
        print(url.absoluteString)
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
