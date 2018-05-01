//
//  MovieParamsSpecs.swift
//  MovieTests
//
//  Created by Navneet on 5/1/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Movie

class MovieParamsSpecs: QuickSpec {
    
    override func spec() {
        var params: MovieParams!
        
        beforeEach() {
            params = MovieParams(query: "batman", page: 1)
        }
        
        describe("Verify service params") {
            context("when intialised", closure: {
                it("should have correct url string", closure: {
                    expect(params.urlString) == "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838&query=batman&page=1"
                })
                
                it("should have valid HTTP method type", closure: {
                    expect(params.httpMethod) == HTTPMethod.GET
                })
                
                it("should have valid HTTP time out", closure: {
                    expect(params.httpTimeout) == HTTPTimeout.fifteen
                })
            })
        }
    }
}
