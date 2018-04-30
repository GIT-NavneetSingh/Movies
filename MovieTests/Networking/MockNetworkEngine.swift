//
//  MockNetworkEngine.swift
//  MovieTests
//
//  Created by Navneet on 4/29/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation
@testable import Movie

class MockError: Error {
    
}

class MockSuccessNetworkEngineWithResults: NetworkEngine {
    var isCalled = false
    func fetch(_ url: URL, completion: @escaping CompletionBlock) {
        isCalled = true

        let movie = Movie(title: "Batman", overview: "Sample", releaseDate: "2012-05-01", posterPath: "somevalue")
        let results = MovieResults(page: 1, totalPages: 6, totalResults: 100, movies: [movie])
        completion(results, nil)
    }
    
    func download(_ url: URL, completion: @escaping DownloadBlock) {
        isCalled = true
        completion(Data())
    }
}

class MockSuccessNetworkEngineWithEmptyResults: NetworkEngine {
    var isCalled = false
    func fetch(_ url: URL, completion: @escaping CompletionBlock) {
        isCalled = true
        
        let results = MovieResults(page: 1, totalPages: 6, totalResults: 100, movies: [])
        completion(results, nil)
    }
}

class MockFailureNetworkEngine: NetworkEngine {
    var isCalled = false
    func fetch(_ url: URL, completion: @escaping CompletionBlock) {
        isCalled = true
        completion(nil, MockError())
    }
    
    func download(_ url: URL, completion: @escaping DownloadBlock) {
        isCalled = true
        completion(nil)
    }
}
