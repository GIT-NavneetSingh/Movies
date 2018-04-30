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
       
        var controller: SearchResultsVC!
        let movie = Movie(title: "Batman", overview: "Sample", releaseDate: "2012-05-01", posterPath: "somevalue")
        let results = MovieResults(page: 1, totalPages: 6, totalResults: 100, movies: [movie])

        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            controller = storyboard.instantiateViewController(withIdentifier: String(describing: SearchResultsVC.self)) as! SearchResultsVC
            
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
        
        describe("Verify fetch results") {
            context("when query string is empty", closure: {
                let serviceHandler = MockFailureNetworkEngine()
                it("should present an alert", closure: {
                    controller.fetchResults(for: nil, page: 2, serviceHandler: serviceHandler)
                    expect(serviceHandler.isCalled).notTo(beTruthy())
                })
            })
            
            context("when textfield is not empty and results are there", closure: {
                let serviceHandler = MockSuccessNetworkEngineWithResults()
                it("should push list VC", closure: {
                    controller.fetchResults(for: "Batman", page: 2, serviceHandler: serviceHandler)
                    expect(serviceHandler.isCalled).to(beTruthy())
                })
            })
            
            context("when textfield is not empty and results are empty", closure: {
                let serviceHandler = MockSuccessNetworkEngineWithEmptyResults()
                it("should present an alert", closure: {
                    controller.fetchResults(for: "Batman", page: 2, serviceHandler: serviceHandler)
                    expect(serviceHandler.isCalled).to(beTruthy())
                })
            })
            
            context("when textfield is not empty and there is an error", closure: {
                let serviceHandler = MockFailureNetworkEngine()
                it("should present an alert", closure: {
                    controller.fetchResults(for: "Batman", page: 2, serviceHandler: serviceHandler)
                    expect(serviceHandler.isCalled).to(beTruthy())
                })
            })
        }
    }
}
