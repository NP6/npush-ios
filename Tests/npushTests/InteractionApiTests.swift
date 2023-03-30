//
//  File.swift
//
//
//  Created by bisenbrandt on 27/03/2023.
//

import Foundation
import XCTest
@testable import npush

final class InteractionApiTests: XCTestCase {
    
    
    var expectation: XCTestExpectation!
    
    var interactionapi: InteractionApi!
    
    var radical: String = "https://tracking.np6.com/MCOM/030/"
    var action: String = "29930NC9N93NFN9201N9F0N39NB3GH2FNqSDP?EOAJDIZJADZ"
    
    override func setUp() {
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        interactionapi = InteractionApi(urlSession)
        
        expectation = expectation(description: "Expectation")
        UserDefaults.resetStandardUserDefaults()
    }
    
    override func tearDown() {
        UserDefaults.resetStandardUserDefaults()
    }
    
    public func testInteractionApiWithBadRequestResponse() {
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
            throw APIResponseError.request
          }
          
          let response = HTTPURLResponse(
            url: URL(string: self.radical + self.action)!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil
          )!
            
          return (response, nil)
        }
        
        interactionapi.get(self.radical, self.action) { result in
            switch(result) {
                case .success(_):
                XCTFail("Success response was not expected.")
                case .failure(let error):
                guard let error = error as? InteractionApi.ApiError else {
                  XCTFail("Incorrect error received.")
                  self.expectation.fulfill()
                  return
                }
                
                XCTAssertEqual(error, InteractionApi.ApiError.NilOrBadHttpResponseCode, "Parsing error was expected.")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 60.0)
    }
    
    public func testInteractionApiWithDataTaskError() {
        
        MockURLProtocol.requestHandler = { request in
            throw InteractionApi.ApiError.DataTaskFailure
        }
        
        interactionapi.get(self.radical, self.action) { result in
            switch(result) {
                case .success(_):
                XCTFail("Success response was not expected.")
                case .failure(let error):
                guard let error = error as? InteractionApi.ApiError else {
                  XCTFail("Incorrect error received.")
                  self.expectation.fulfill()
                  return
                }
                
                XCTAssertEqual(error, InteractionApi.ApiError.DataTaskFailure, "Parsing error was expected.")
            }
            self.expectation.fulfill()

        }
        wait(for: [expectation], timeout: 60.0)
    }
    
    public func testSubscriptionApiWitOkHttpResponse() {
        
        MockURLProtocol.requestHandler = { request in
          let response = HTTPURLResponse(
            url: URL(string: self.radical + self.action)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
          )!
            
          return (response, nil)
        }
        
        interactionapi.get(self.radical, self.action) { result in
            switch(result) {
                case .success(_):
                    XCTAssert(true)
                case .failure(_):
                    XCTFail("Failed response was not expected.")
                    self.expectation.fulfill()
                return
                
            }
            self.expectation.fulfill()

        }
        wait(for: [expectation], timeout: 60.0)
    }
}



