//
//  MovieListTableVCSpecs.swift
//  MovieTests
//
//  Created by Navneet on 4/29/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Movie

class MovieListTableVCSpecs: QuickSpec {
    
    override func spec() {
       
        var controller: MovieListTableVC!
        let movie = Movie(title: "Batman", overview: "Sample", releaseDate: "2012-05-01", posterPath: "somevalue")
        let results = Results(page: 1, totalPages: 6, totalResults: 100, movies: [movie])

        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            controller = storyboard.instantiateViewController(withIdentifier: String(describing: MovieListTableVC.self)) as! MovieListTableVC
            
            controller.viewModel = MovieListViewModel(movie: "Batman", results: results)
            _ = controller.view
        }
        
        describe("Verify controller's state") {
            context("when initialised", closure: {
                it("should not be nil", closure: {
                    expect(controller).notTo(beNil())
                })
                
                it("should have correct uppercased title", closure: {
                    expect(controller.title) == movie.title?.uppercased()
                })
                
                it("should have correct numbers of rows", closure: {
                    expect(controller.tableView.numberOfSections) == results.movies.count
                })
            })
        }
    }
}
