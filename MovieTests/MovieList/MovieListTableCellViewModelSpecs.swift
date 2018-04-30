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
    }
}
