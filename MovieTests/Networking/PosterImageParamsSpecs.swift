//
//  PosterImageParamsSpecs.swift
//  MovieTests
//
//  Created by Navneet on 5/1/18.
//  Copyright © 2018 Navneet. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Movie

class PosterImageParamsSpecs: QuickSpec {
    
    override func spec() {
        var params: PosterImageParams!
        
        beforeEach() {
            params = PosterImageParams(path: "/2DtPSyODKWXluIRV7PVru0SSzja.jpg")
        }
        
        describe("Verify service params") {
            context("when intialised", closure: {
                it("should have correct url string", closure: {
                    expect(params.urlString) == "http://image.tmdb.org/t/p/w92/2DtPSyODKWXluIRV7PVru0SSzja.jpg"
                })
                
                it("should have valid HTTP method type", closure: {
                    expect(params.httpMethod) == HTTPMethod.GET
                })
                
                it("should have valid HTTP time out", closure: {
                    expect(params.httpTimeout) == HTTPTimeout.thirty
                })
            })
        }
    }
}
