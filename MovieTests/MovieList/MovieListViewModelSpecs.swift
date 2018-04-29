//
//  MovieListViewModelSpecs.swift
//  MovieTests
//
//  Created by Navneet on 4/29/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Movie

private class MockNetworkEngine: NetworkEngine {
    var isCalled = false
    override func fetch(_ url: URL, completion: @escaping CompletionBlock) {
        isCalled = true
    }
}

class MovieListViewModelSpecs: QuickSpec {
    
    override func spec() {
        
        var viewModel: MovieListViewModel!
        let movie = Movie(title: "Batman", overview: "Sample", releaseDate: "2012-05-01", posterPath: "somevalue")
        let results = Results(page: 1, totalPages: 6, totalResults: 100, movies: [movie])
        
        beforeEach {
            viewModel = MovieListViewModel(movie: "Batman", results: results)
        }
        
        describe("Verify state of view model") {
            context("when initialised", closure: {
                it("should have requied attributes", closure: {
                    expect(viewModel.movie) == movie.title
                    expect(viewModel.results?.movies.count) === results.movies.count
                })
            })
        }
        
        describe("Verify page") {
            context("when called", closure: {
                var engine: MockNetworkEngine!
                beforeEach {
                    engine = MockNetworkEngine()
                    viewModel.engine = engine
                }
                
                it("should called fetch of network engine if query is correct", closure: {
                    viewModel.loadPage(2, completion: { _,_  in
                        expect(engine.isCalled).to(beTruthy())
                    })
                })
                
                it("should not called network engine if query is incorrect", closure: {
                    viewModel = MovieListViewModel(movie: nil, results: results)
                    viewModel.loadPage(2, completion: { _,_  in
                        expect(engine.isCalled).notTo(beTruthy())
                    })
                })
            })
        }
    }
}
