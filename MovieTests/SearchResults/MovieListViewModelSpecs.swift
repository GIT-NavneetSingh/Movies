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

class MovieListViewModelSpecs: QuickSpec {
    
    override func spec() {
        
        var viewModel: SearchResultsViewModel!
        let movie = Movie(title: "Batman", overview: "Sample", releaseDate: "2012-05-01", posterPath: "somevalue")
        let results = MovieResults(page: 1, totalPages: 6, totalResults: 100, movies: [movie])
        
        beforeEach {
            viewModel = SearchResultsViewModel(movie: "Batman", results: results)
        }
        
        describe("Verify state of view model") {
            context("when initialised", closure: {
                it("should have requied attributes", closure: {
                    expect(viewModel.movie) == movie.title
                    expect(viewModel.movies.count) === results.movies.count
                })
            })
        }
    }
}
