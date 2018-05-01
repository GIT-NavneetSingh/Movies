//
//  SearchViewModelSpecs.swift
//  MovieTests
//
//  Created by Navneet on 5/1/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation

import Foundation
import Quick
import Nimble
@testable import Movie

class SearchViewModelSpecs: QuickSpec {
    
    override func spec() {
        
        var viewModel: SearchViewModel!
        
        beforeEach {
            viewModel = SearchViewModel(title: "Search", searchQuery: "")
        }
        
        describe("Verify state of view model") {
            context("when initialised", closure: {
                it("should have requied attributes", closure: {
                    expect(viewModel.title) == "Search"
                })
            })
        }
        
        fdescribe("Verify persisted data") {
            afterEach {
                UserDefaults.standard.removeObject(forKey: "RecentSearchedMovies")
            }
            
            context("when persiting an invalid string", closure: {
                beforeEach {
                    viewModel.persistSearchQuery(nil)
                }
                
                it("should have an empty search query", closure: {
                    expect(viewModel.searchQuery) == ""
                })
            })
            
            context("when persiting a valid string, when there is no persisted list", closure: {
                beforeEach {
                    viewModel.persistSearchQuery("Batman")
                }
                
                it("should have a valid search query", closure: {
                    expect(viewModel.searchQuery) == "batman"
                })
            })
            
            context("when persiting a valid string, when there is a persisted list", closure: {
                beforeEach {
                    UserDefaults.standard.set(["Superman"], forKey: "RecentSearchedMovies")
                    viewModel.persistSearchQuery("Batman")
                }
                
                it("should have a valid search query", closure: {
                    expect(viewModel.searchQuery) == "batman"
                    expect(UserDefaults.standard.array(forKey: "RecentSearchedMovies")?.count) == 2
                })
            })
        }
    }
}
