//
//  SearchResultsVCSpecs.swift
//  MovieTests
//
//  Created by Navneet on 4/29/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Movie

class SearchResultsVCSpecs: QuickSpec {
    
    override func spec() {
       
        var controller: SearchResultsVC!
        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            controller = storyboard.instantiateViewController(withIdentifier: String(describing: SearchResultsVC.self)) as! SearchResultsVC
        }
        
        describe("Verify controller's state") {
            let movie = Movie(title: "Batman", overview: "Sample", releaseDate: "2012-05-01", posterPath: "somevalue")
            let results = MovieResults(page: 1, totalPages: 6, totalResults: 100, movies: [movie])

            beforeEach {
                controller.viewModel = SearchResultsViewModel(movie: "Batman", results: results)
                _ = controller.view
            }
            
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
                let serviceController = MockFailureMoviesServiceController()
                let movie = Movie(title: "Batman", overview: "Sample", releaseDate: "2012-05-01", posterPath: "somevalue")
                let results = MovieResults(page: 1, totalPages: 2, totalResults: 6, movies: [movie])

                beforeEach {
                    controller.viewModel = SearchResultsViewModel(movie: nil, results: results)
                    controller.serviceController = serviceController
                    _ = controller.view
                    
                    controller.tableView(UITableView(), willDisplay: UITableViewCell(), forRowAt: IndexPath(row: 1, section: (controller.viewModel?.movies?.count)! - 1))
                }
                
                it("should not call service", closure: {
                    expect(serviceController.isCalled).notTo(beTruthy())
                })
            })
            
            context("when there are no page to load", closure: {
                let serviceController = MockFailureMoviesServiceController()
                let movie = Movie(title: "Batman", overview: "Sample", releaseDate: "2012-05-01", posterPath: "somevalue")
                let results = MovieResults(page: 1, totalPages: 1, totalResults: 1, movies: [movie])
                
                beforeEach {
                    controller.viewModel = SearchResultsViewModel(movie: movie.title, results: results)
                    controller.serviceController = serviceController
                    _ = controller.view
                    
                    controller.tableView(UITableView(), willDisplay: UITableViewCell(), forRowAt: IndexPath(row: 1, section: (controller.viewModel?.movies?.count)! - 1))
                }
                
                it("should not call service", closure: {
                    expect(serviceController.isCalled).notTo(beTruthy())
                })
            })
            
            context("when there are page to load and it return results", closure: {
                let serviceController = MockSuccessMoviesServiceControllerWithResults()
                let movie = Movie(title: "Batman", overview: "Sample", releaseDate: "2012-05-01", posterPath: "somevalue")
                let results = MovieResults(page: 1, totalPages: 2, totalResults: 2, movies: [movie])
                
                var countBefore: Int!
                beforeEach {
                    controller.viewModel = SearchResultsViewModel(movie: movie.title, results: results)
                    controller.serviceController = serviceController
                    _ = controller.view
                    
                    countBefore = controller.viewModel?.movies?.count
                    controller.tableView(UITableView(), willDisplay: UITableViewCell(), forRowAt: IndexPath(row: 1, section: (controller.viewModel?.movies?.count)! - 1))
                }
                
                it("should call service", closure: {
                    expect(serviceController.isCalled).to(beTruthy())
                })
                
                it("should increase movies count", closure: {
                    expect(controller.viewModel?.movies?.count).toEventually(beGreaterThan(countBefore))
                })
            })
            
            context("when there are page to load and it return empty results", closure: {
                let serviceController = MockSuccessMoviesServiceControllerWithEmptyResults()
                let movie = Movie(title: "Batman", overview: "Sample", releaseDate: "2012-05-01", posterPath: "somevalue")
                let results = MovieResults(page: 1, totalPages: 2, totalResults: 2, movies: [movie])
                
                var countBefore: Int!
                beforeEach {
                    controller.viewModel = SearchResultsViewModel(movie: movie.title, results: results)
                    controller.serviceController = serviceController
                    _ = controller.view
                    
                    countBefore = controller.viewModel?.movies?.count
                    controller.tableView(UITableView(), willDisplay: UITableViewCell(), forRowAt: IndexPath(row: 1, section: (controller.viewModel?.movies?.count)! - 1))
                }
                
                it("should call service", closure: {
                    expect(serviceController.isCalled).to(beTruthy())
                })
                
                it("should increase movies count", closure: {
                    expect(controller.viewModel?.movies?.count).toEventually(equal(countBefore))
                })
            })
        }
    }
}
