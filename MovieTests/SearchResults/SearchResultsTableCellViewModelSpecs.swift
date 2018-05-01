//
//  SearchResultsTableCellViewModelSpecs.swift
//  MovieTests
//
//  Created by Navneet on 4/30/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Movie

class SearchResultsTableCellViewModelSpecs: QuickSpec {
    
    override func spec() {
        
        var viewModel: SearchResultCellViewModel!
        let movie = Movie(title: "Batman", overview: "Sample", releaseDate: "2012-05-01", posterPath: "somevalue")

        beforeEach {
            viewModel = SearchResultCellViewModel(movie: movie, cache: NSCache<NSString, UIImage>())
        }
        
        describe("Verify state of view model") {
            context("when initialised", closure: {
                it("should have requied attributes", closure: {
                    expect(viewModel.title) == movie.title
                    expect(viewModel.imageCache).notTo(beNil())
                })
            })
        }
    }
}
