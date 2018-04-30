//
//  NetworkEngine.swift
//  Movie
//
//  Created by Navneet on 4/25/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation
import UIKit

public typealias CompletionBlock = (_ results: MovieResults?, _ error: Error?) -> ()
public typealias DownloadBlock = (_ data: Data?) -> ()

protocol NetworkEngine {
    func fetch(_ url: URL, completion: @escaping CompletionBlock)
    func download(_ url: URL, completion: @escaping DownloadBlock)
}

extension NetworkEngine {
    func fetch(_ url: URL, completion: @escaping CompletionBlock) {
        
    }
    
    func download(_ url: URL, completion: @escaping DownloadBlock) {
        
    }
}
