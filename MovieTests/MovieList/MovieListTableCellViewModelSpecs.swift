//
//  MovieListTableCellViewModelSpecs.swift
//  MovieTests
//
//  Created by Navneet on 4/30/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Movie

private class MockNetworkEngine: NetworkEngine {
    var isCalled = false
    override func download(_ url: URL, completion: @escaping DownloadBlock) {
        isCalled = true
    }
}

class MovieListTableCellViewModelSpecs: QuickSpec {
    
    override func spec() {
        
        var viewModel: MovieListTableCellViewModel!
        let movie = Movie(title: "Batman", overview: "Sample", releaseDate: "2012-05-01", posterPath: "somevalue")

        beforeEach {
            viewModel = MovieListTableCellViewModel(movie: movie, cache: NSCache<AnyObject, AnyObject>())
        }
        
        describe("Verify state of view model") {
            context("when initialised", closure: {
                it("should have requied attributes", closure: {
                    expect(viewModel.movie.title) == movie.title
                    expect(viewModel.cache).notTo(beNil())
                })
            })
        }
        
        describe("Verify fetching Image") {
            context("when called", closure: {
                var engine: MockNetworkEngine!
                beforeEach {
                    engine = MockNetworkEngine()
                    viewModel.engine = engine
                }
                
                it("should called fetch of network engine if query is correct", closure: {
                    viewModel.fetchImage(from: movie.posterPath, completion: { _ in
                        expect(engine.isCalled).to(beTruthy())
                    })
                })
                
                it("should not called network engine if query is incorrect", closure: {
                    viewModel.fetchImage(from: nil, completion: { _ in
                        expect(engine.isCalled).notTo(beTruthy())
                    })
                })
            })
        }
    }
}
