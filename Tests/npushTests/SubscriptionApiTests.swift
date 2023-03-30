//
//  File.swift
//  
//
//  Created by bisenbrandt on 27/03/2023.
//

import Foundation


//
//  File.swift
//
//
//  Created by bisenbrandt on 27/03/2023.
//

import Foundation

import XCTest
@testable import npush

final class SubscriptionApiTests: XCTestCase {
    
    
    var expectation: XCTestExpectation!
    
    var subscriptionApi: SubscriptionApi!
    
    let baseUrl: String = "http://cm-push.kube.dev.np6.com/api/v1.0/"
    
    override func setUp() {
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        subscriptionApi = SubscriptionApi(baseUrl, urlSession)
        
        expectation = expectation(description: "Expectation")
        UserDefaults.resetStandardUserDefaults()
    }
    
    override func tearDown() {
        UserDefaults.resetStandardUserDefaults()
    }
    
    public func testSubscriptionApiWithBadRequestResponse() {
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
            throw APIResponseError.request
          }
          
          let response = HTTPURLResponse(
            url: URL(string: self.baseUrl)!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil
          )!
            
          return (response, nil)
        }

        let subscription: Subscription = Subscription(
            application: UUID(),
            gateway: Gateway(token: "token"),
            linked: Linked(type: "hash", identifier: "hash")
        )
        
        subscriptionApi.put(subscription) { result in
            switch(result) {
                case .success(_):
                XCTFail("Success response was not expected.")
                case .failure(let error):
                guard let error = error as? SubscriptionApi.ApiError else {
                  XCTFail("Incorrect error received.")
                  self.expectation.fulfill()
                  return
                }
                
                XCTAssertEqual(error, SubscriptionApi.ApiError.NilOrBadHttpResponseCode, "Parsing error was expected.")
            }
            self.expectation.fulfill()

        }
        wait(for: [expectation], timeout: 60.0)
    }
    
    public func testSubscriptionApiWithDataTaskError() {
        
        MockURLProtocol.requestHandler = { request in
            throw SubscriptionApi.ApiError.DataTaskFailure
        }

        let subscription: Subscription = Subscription(
            application: UUID(),
            gateway: Gateway(token: "token"),
            linked: Linked(type: "hash", identifier: "hash")
        )
        
        subscriptionApi.put(subscription) { result in
            switch(result) {
                case .success(_):
                XCTFail("Success response was not expected.")
                case .failure(let error):
                guard let error = error as? SubscriptionApi.ApiError else {
                  XCTFail("Incorrect error received.")
                  self.expectation.fulfill()
                  return
                }
                
                XCTAssertEqual(error, SubscriptionApi.ApiError.DataTaskFailure, "Parsing error was expected.")
            }
            self.expectation.fulfill()

        }
        wait(for: [expectation], timeout: 60.0)
    }
    
    public func testSubscriptionApiWitOkHttpResponse() {
        
        MockURLProtocol.requestHandler = { request in
          let response = HTTPURLResponse(
            url: URL(string: self.baseUrl)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
          )!
            
          return (response, nil)
        }

        let subscription: Subscription = Subscription(
            application: UUID(),
            gateway: Gateway(token: "token"),
            linked: Linked(type: "hash", identifier: "hash")
        )
        
        subscriptionApi.put(subscription) { result in
            switch(result) {
                case .success(let response):
                    XCTAssert(response.id == subscription.id)
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



