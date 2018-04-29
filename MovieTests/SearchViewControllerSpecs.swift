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
                    expect(controller.presentedViewController is RecentSearchTableVC).toEventually(beTruthy())
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
                    expect(controller.presentedViewController is RecentSearchTableVC).toEventuallyNot(beTruthy())
                })
            })
        }
        
        describe("Verify action on the search button") {
            context("when textfield is empty", closure: {
                beforeEach {
                    controller.txtField.text = ""
                }
                
                it("should present an alert", closure: {
                    controller.searchAction(controller)
                    expect(controller.presentedViewController is UIAlertController).toEventually(beTruthy())
                })
            })
            
            context("when textfield is not empty and results are there", closure: {
                var query: String!
                beforeEach {
                    query = "Batman"
                    controller.txtField.text = query
                    controller.engine = MockSuccessNetworkEngineWithResults()
                    controller.searchAction(controller)
                }
                
                it("should push list VC", closure: {
                    expect(controller.navigationController?.topViewController is MovieListTableVC).toEventually(beTruthy())
                })
            })
            
            context("when textfield is not empty and results are empty", closure: {
                beforeEach {
                    controller.txtField.text = "Batman"
                    controller.engine = MockSuccessNetworkEngineWithEmptyResults()
                }
                
                it("should present an alert", closure: {
                    controller.searchAction(controller)
                    expect(controller.presentedViewController is UIAlertController).toEventually(beTruthy())
                })
            })
            
            context("when textfield is not empty and there is an error", closure: {
                beforeEach {
                    controller.txtField.text = "Batman"
                    controller.engine = MockFailureNetworkEngine()
                }
                
                it("should present an alert", closure: {
                    controller.searchAction(controller)
                    expect(controller.presentedViewController is UIAlertController).toEventually(beTruthy())
                })
            })
        }
    }
}
