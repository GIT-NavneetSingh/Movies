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
            func downloadImage(from path: String, completion: DownloadBlock) {
                isCalled = true
                completion?(UIImagePNGRepresentation(#imageLiteral(resourceName: "default_image")))
            }
        }
    
        class MockFailureServiceController: DataDownloadable {
            var isCalled = false
            func downloadImage(from path: String, completion: DownloadBlock) {
                isCalled = true
                completion?(nil)
            }
        }
        
        var cell: SearchResultsTableViewCell!
        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: String(describing: SearchResultsVC.self)) as! SearchResultsVC
            
            cell = controller.tableView.dequeueReusableCell(withIdentifier: String(describing: SearchResultsTableViewCell.self)) as! SearchResultsTableViewCell
        }
        
        describe("Verify cell state") {
            context("when configured", closure: {
                let movie = Movie(title: "Batman", overview: "Some Value", releaseDate: "2015-10-01", posterPath: "some value")
                let cache = NSCache<NSString, UIImage>()
                let viewModel = SearchResultCellViewModel(movie: movie, cache: cache)
                
                beforeEach {
                    cell.viewModel = viewModel
                    cell.configureView()
                }
                
                it("should have title", closure: {
                    expect(viewModel.title) == movie.title
                })
                
                it("should have overview", closure: {
                    expect(viewModel.overview) == movie.overview
                })
                
                it("should have release date", closure: {
                    expect(viewModel.releaseDate) == movie.releaseDate
                })
            })
        }
        
        describe("Verify download image") {
            context("when poster path empty", closure: {
                let movie = Movie(title: "Batman", overview: "Some Value", releaseDate: "2015-10-01", posterPath: nil)
                let cache = NSCache<NSString, UIImage>()
                let viewModel = SearchResultCellViewModel(movie: movie, cache: cache)
                
                let serviceController = MockFailureServiceController()
                beforeEach {
                    cell.viewModel = viewModel
                    cell.serviceController = serviceController
                    cell.configureView()
                }
                
                it("should not called serviceController" , closure: {
                    expect(serviceController.isCalled).notTo(beTruthy())
                })
            })
            
            context("when poster path is not empty and receives response", closure: {
                let movie = Movie(title: "Batman", overview: "Some Value", releaseDate: "2015-10-01", posterPath: "some value")
                let cache = NSCache<NSString, UIImage>()
                let viewModel = SearchResultCellViewModel(movie: movie, cache: cache)
                
                let serviceController = MockSuccessServiceController()
                beforeEach {
                    cell.viewModel = viewModel
                    cell.serviceController = serviceController
                    cell.configureView()
                }

                it("should called serviceController", closure: {
                    expect(serviceController.isCalled).to(beTruthy())
                })
                
                it("should set image to imageview" , closure: {
                    expect(cell.posterImgView.image).notTo(beNil())
                })
            })
            
            context("when poster path is not empty and receives error", closure: {
                let movie = Movie(title: "Batman", overview: "Some Value", releaseDate: "2015-10-01", posterPath: "some value")
                let cache = NSCache<NSString, UIImage>()
                let viewModel = SearchResultCellViewModel(movie: movie, cache: cache)
                
                let serviceController = MockFailureServiceController()
                beforeEach {
                    cell.viewModel = viewModel
                    cell.serviceController = serviceController
                    cell.configureView()
                }
                
                it("should not called serviceController" , closure: {
                    expect(serviceController.isCalled).to(beTruthy())
                })
            })
        }
    }
}
