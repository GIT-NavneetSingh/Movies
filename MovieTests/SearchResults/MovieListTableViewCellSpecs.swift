//
//  MovieListTableViewCellSpecs.swift
//  MovieTests
//
//  Created by Navneet on 4/30/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Movie

class MovieListTableViewCellSpecs: QuickSpec {
    
    override func spec() {
        
        class MockSuccessServiceController: DataDownloadable {
            var isCalled = false
            func download(_ url: URL, completion: @escaping DownloadBlock) {
                isCalled = true
                completion(Data())
            }
        }
    
        class MockFailureServiceController: DataDownloadable {
            var isCalled = false
            func download(_ url: URL, completion: @escaping DownloadBlock) {
                isCalled = true
                completion(nil)
            }
        }
        
        var cell: SearchResultsTableViewCell!
        let movie = Movie(title: "Batman", overview: "Some Value", releaseDate: "2015-10-01", posterPath: "some value")
        let cache = NSCache<AnyObject, AnyObject>()
        let viewModel = SearchResultCellViewModel(movie: movie, cache: cache)
        
        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: String(describing: SearchResultsVC.self)) as! SearchResultsVC
            
            cell = controller.tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultsTableViewCell.self)) as! SearchResultsTableViewCell
        }
        
        describe("Verify cell state") {
            context("when configured", closure: {
                beforeEach {
                    cell.configureView()
                }
                
                it("should have title", closure: {
                    expect(viewModel.movie?.title) == movie.title
                })
                
                it("should have overview", closure: {
                    expect(viewModel.movie?.overview) == movie.overview
                })
                
                it("should have release date", closure: {
                    expect(viewModel.movie?.releaseDate) == movie.releaseDate
                })
            })
        }
        
        describe("Verify download image") {
            context("when image is not cached", closure: {
                beforeEach {
                    cell.configureView()
                }
                
                context("when poster path empty", closure: {
                    let serviceHandler = MockFailureServiceController()
                    it("should present an alert", closure: {
                        cell.fetchImage(from: nil, serviceController: serviceHandler)
                        expect(serviceHandler.isCalled).notTo(beTruthy())
                    })
                })
                
                context("when poster path is not empty and receives response", closure: {
                    let serviceHandler = MockSuccessServiceController()
                    it("should push list VC", closure: {
                        cell.fetchImage(from: movie.posterPath, serviceController: serviceHandler)
                        expect(serviceHandler.isCalled).to(beTruthy())
                    })
                })
                
                context("when poster path is not empty and receives error", closure: {
                    let serviceHandler = MockFailureServiceController()
                    it("should present an alert", closure: {
                        cell.fetchImage(from: movie.posterPath, serviceController: serviceHandler)
                        expect(serviceHandler.isCalled).to(beTruthy())
                    })
                })
            })
        }
    }
}
