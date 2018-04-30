//
//  SearchViewControllerSpecs.swift
//  MovieTests
//
//  Created by Navneet on 4/29/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Movie

class SearchViewControllerSpecs: QuickSpec {
    
    override func spec() {

        var controller: SearchViewController!
        beforeEach {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            controller = storyboard.instantiateViewController(withIdentifier: String(describing: SearchViewController.self)) as! SearchViewController
            let navigation = UINavigationController(rootViewController: controller)
            let window = UIWindow()
            window.rootViewController = navigation
            window.makeKeyAndVisible()
            _ = navigation.view
            _ = controller.view
        }
        
        describe("Verify controller's state") {
            context("when initialised", closure: {
                it("should not be nil", closure: {
                    expect(controller).notTo(beNil())
                })
            })
        }
        
        describe("Verify presentation of stored list") {
            context("when there are stored values", closure: {
                beforeEach {
                    UserDefaults.standard.set(["Batman", "Superman"], forKey: "RecentSearchedMovies")
                }
                
                afterEach {
                    UserDefaults.standard.removeObject(forKey: "RecentSearchedMovies")
                }
                
                it("should present list", closure: {
                    controller.didTouchDownTextField(UITextField())
                    expect(controller.presentedViewController is RecentSearchVC).toEventually(beTruthy())
                })
            })
            
            context("when there are no or empty stored values", closure: {
                beforeEach {
                    UserDefaults.standard.set([], forKey: "RecentSearchedMovies")
                }
                
                afterEach {
                    UserDefaults.standard.removeObject(forKey: "RecentSearchedMovies")
                }
                
                it("should not present list", closure: {
                    controller.didTouchDownTextField(UITextField())
                    expect(controller.presentedViewController is RecentSearchVC).toEventuallyNot(beTruthy())
                })
            })
        }
        
        describe("Verify search action") {
            context("when query string is empty", closure: {
                let serviceController = MockSuccessMoviesServiceControllerWithResults()
                beforeEach {
                    controller.serviceController = serviceController
                    controller.txtField.text = nil
                    controller.searchAction()
                }
                
                it("should present an alert", closure: {
                    expect(serviceController.isCalled).notTo(beTruthy())
                    expect(controller.presentedViewController is UIAlertController).toEventually(beTruthy())
                })
            })
            
            context("when textfield is not empty and results are there", closure: {
                let serviceController = MockSuccessMoviesServiceControllerWithResults()
                beforeEach {
                    controller.serviceController = serviceController
                    controller.txtField.text = "Batman"
                    controller.searchAction()
                }
                
                it("should push list VC", closure: {
                    expect(serviceController.isCalled).to(beTruthy())
                    expect(controller.navigationController?.topViewController is SearchResultsVC).toEventually(beTruthy())
                })
            })
            
            context("when textfield is not empty and results are empty", closure: {
                let serviceController = MockSuccessMoviesServiceControllerWithEmptyResults()
                beforeEach {
                    controller.serviceController = serviceController
                    controller.txtField.text = "Batman"
                    controller.searchAction()
                }
                
                it("should present an alert", closure: {
                    expect(serviceController.isCalled).to(beTruthy())
                    expect(controller.presentedViewController is UIAlertController).toEventually(beTruthy())
                })
            })
            
            context("when textfield is not empty and there is an error", closure: {
                let serviceController = MockFailureMoviesServiceController()
                beforeEach {
                    controller.serviceController = serviceController
                    controller.txtField.text = "Batman"
                    controller.searchAction()
                }
                
                it("should present an alert", closure: {
                    expect(serviceController.isCalled).to(beTruthy())
                    expect(controller.presentedViewController is UIAlertController).toEventually(beTruthy())
                })
            })
        }
    }
}
