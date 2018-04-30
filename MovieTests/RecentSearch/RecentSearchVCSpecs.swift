//
//  RecentSearchVCSpecs.swift
//  MovieTests
//
//  Created by Navneet on 4/29/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Movie

class RecentSearchVCSpecs: QuickSpec {
    
    override func spec() {
        var controller: RecentSearchVC!

        beforeEach {
            UserDefaults.standard.set(["Movie 1", "Movie 2", "Movie 3", "Movie 4", "Movie 5", "Movie 6", "Movie 7", "Movie 8", "Movie 9", "Movie 10", "Movie 11"], forKey: "RecentSearchedMovies")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            controller = storyboard.instantiateViewController(withIdentifier: String(describing: RecentSearchVC.self)) as! RecentSearchVC
            _ = controller.view
        }
        
        afterEach {
            UserDefaults.standard.removeObject(forKey: "RecentSearchedMovies")
        }
        
        describe("Verify controller's state") {
            context("when initialised", closure: {
                it("should not be nil", closure: {
                    expect(controller).notTo(beNil())
                })
            })
        }
        
        describe("Verify tableview state") {
            context("when items count is more than max limit", closure: {
                it("table should have 10 rows", closure: {
                    expect(controller.tableView.numberOfRows(inSection: 0)) == 10
                })
            })
        }
    }
}
