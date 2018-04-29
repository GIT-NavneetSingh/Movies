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
    override func fetch(_ url: URL, completion: @escaping CompletionBlock) {
        let movie = Movie(title: "Batman", overview: "Sample", releaseDate: "2012-05-01", posterPath: "somevalue")
        let results = Results(page: 1, totalPages: 6, totalResults: 100, movies: [movie])
        completion(results, nil)
    }
}

class MockSuccessNetworkEngineWithEmptyResults: NetworkEngine {
    override func fetch(_ url: URL, completion: @escaping CompletionBlock) {
        let results = Results(page: 1, totalPages: 6, totalResults: 100, movies: [])
        completion(results, nil)
    }
}

class MockFailureNetworkEngine: NetworkEngine {
    var isInvokeHashServiceCalled = false
    override func fetch(_ url: URL, completion: @escaping CompletionBlock) {
        completion(nil, MockError())
    }
}
