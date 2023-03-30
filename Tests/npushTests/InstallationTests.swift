//
//  File.swift
//  
//
//  Created by bisenbrandt on 27/03/2023.
//

import Foundation

import XCTest
@testable import npush


final class InstallationTests: XCTestCase {
    
    var expectation: XCTestExpectation!
    
    var subscriptionApi: SubscriptionApi!
    
    let baseUrl: String = "http://cm-push.kube.dev.np6.com/api/v1.0/"

    
    let config = Config(identity: "MCOM032", application: UUID())

    override func setUp() {
        
        
        let configuration = URLSessionConfiguration.default
       
        configuration.protocolClasses = [MockURLProtocol.self]
        
        let urlSession = URLSession.init(configuration: configuration)
        
        self.subscriptionApi = SubscriptionApi(baseUrl, urlSession)

        expectation = expectation(description: "Expectation")

        UserDefaults.resetStandardUserDefaults()
    }
    
    override func tearDown() {
        UserDefaults.resetStandardUserDefaults()
    }
    
    
    public func testGetIdentifierWithoutWithoutIdentifier()
    {
        
        let identifierRepositoryMock = IdentifierRepositoryMock(localStorage: UserDefaultStorage(namespace: IdentifierRepository.namespace))
        
        identifierRepositoryMock.existMock = {
            return false;
        }
        
        identifierRepositoryMock.addMock = { element in
            return element;
        }

        let tokenRepositoryMock = TokenRepositoryMock(localStorage: UserDefaultStorage(namespace: IdentifierRepository.namespace))
                
        let installation = Installation(self.config, identifierRepositoryMock , tokenRepositoryMock, self.subscriptionApi)
        
        
        _ = installation.getIdentifier()
        
        XCTAssertEqual(identifierRepositoryMock.getExistCount(), 1)
        XCTAssertEqual(identifierRepositoryMock.getGetCount(), 0)
        XCTAssertEqual(identifierRepositoryMock.getAddCount(), 1)
        
        self.expectation.fulfill()
        wait(for: [expectation], timeout: 60.0)

    }
    
    
    public func testGetIdentifierWithoutWithExistingIdentifier()
    {
        
        let identifierRepositoryMock = IdentifierRepositoryMock(localStorage: UserDefaultStorage(namespace: IdentifierRepository.namespace))
        
        identifierRepositoryMock.existMock = {
            return true;
        }
        
        identifierRepositoryMock.addMock = { element in
            return element;
        }

        let tokenRepositoryMock = TokenRepositoryMock(localStorage: UserDefaultStorage(namespace: IdentifierRepository.namespace))
        
        let config = Config(identity: "MCOM032", application: UUID())
        
        let installation = Installation(self.config, identifierRepositoryMock , tokenRepositoryMock, self.subscriptionApi)
        
        
        _ = installation.getIdentifier()
        
        XCTAssertEqual(identifierRepositoryMock.getExistCount(), 1)
        XCTAssertEqual(identifierRepositoryMock.getGetCount(), 1)
        XCTAssertEqual(identifierRepositoryMock.getAddCount(), 0)
        
        self.expectation.fulfill()
        wait(for: [expectation], timeout: 60.0)

        
    }
    
    public func testSubscribeWithUnexistingToken()
    {
        let identifierRepositoryMock = IdentifierRepositoryMock(localStorage: UserDefaultStorage(namespace: IdentifierRepository.namespace))
        
        identifierRepositoryMock.existMock = {
            return false;
        }
        
        let tokenRepositoryMock = TokenRepositoryMock(localStorage: UserDefaultStorage(namespace: IdentifierRepository.namespace))
                
        tokenRepositoryMock.existMock = {
            return false
        }
        let installation = Installation(self.config, identifierRepositoryMock , tokenRepositoryMock, self.subscriptionApi)
                
        let linked = Linked(type: "hash", identifier: "C?S0Q9S8AG5ECA8C9?EKOCEJFEH")
        
        installation.subscribe(linked) { result in
            switch(result) {
            case .success(let subscription):
                XCTFail("Success response was not expected.")
            case .failure(let error):
                
                guard let error = error as? Installation.InstallationError else {
                  XCTFail("Incorrect error received.")
                  self.expectation.fulfill()
                  return
                }
                
                XCTAssertEqual(error, Installation.InstallationError.EmptyOrNullToken, "Parsing error was expected.")
                
                XCTAssertEqual(identifierRepositoryMock.getExistCount(), 0)
                XCTAssertEqual(identifierRepositoryMock.getGetCount(), 0)
                XCTAssertEqual(identifierRepositoryMock.getAddCount(), 0)
                
                XCTAssertEqual(tokenRepositoryMock.getExistCount(), 1)
                XCTAssertEqual(tokenRepositoryMock.getGetCount(), 0)
                XCTAssertEqual(tokenRepositoryMock.getAddCount(), 0)

            }

            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 60.0)
        
    }
    
    public func testSubscribeWithExistingTokenAndIdentifier()
    {
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
            throw APIResponseError.request
          }
          
          let response = HTTPURLResponse(
            url: URL(string: self.baseUrl)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
          )!
            
          return (response, nil)
        }

        
        let identifierRepositoryMock = IdentifierRepositoryMock(localStorage: UserDefaultStorage(namespace: IdentifierRepository.namespace))
        
        identifierRepositoryMock.existMock = {
            return true;
        }
        
        identifierRepositoryMock.getMock = {
            return "d8b565a9-115e-439c-8861-eea6071b911d";
        }

        let tokenRepositoryMock = TokenRepositoryMock(localStorage: UserDefaultStorage(namespace: IdentifierRepository.namespace))
                
        tokenRepositoryMock.existMock = {
            return true
        }
        
        tokenRepositoryMock.getMock = {
            return "ekozpekfpezokfpzeokfpogezkpokfpoezkf"
        }

        let installation = Installation(self.config, identifierRepositoryMock , tokenRepositoryMock, self.subscriptionApi)
                
        let linked = Linked(type: "hash", identifier: "C?S0Q9S8AG5ECA8C9?EKOCEJFEH")
        
        
        installation.subscribe(linked) { result in
            switch(result) {
            case .success(let subscription):
                
                XCTAssertEqual(identifierRepositoryMock.getExistCount(), 1)
                XCTAssertEqual(identifierRepositoryMock.getGetCount(), 1)
                XCTAssertEqual(identifierRepositoryMock.getAddCount(), 0)
                
                XCTAssertEqual(tokenRepositoryMock.getExistCount(), 1)
                XCTAssertEqual(tokenRepositoryMock.getGetCount(), 1)
                XCTAssertEqual(tokenRepositoryMock.getAddCount(), 0)


                XCTAssertEqual(subscription.id.uuidString, "d8b565a9-115e-439c-8861-eea6071b911d".uppercased(), "Subscription uuid mismatch with mock")
                XCTAssertEqual(subscription.gateway.token, "ekozpekfpezokfpzeokfpogezkpokfpoezkf", "Subscription token mismatch with mock")
           
            case .failure(let error):
                XCTFail("Incorrect error received.")
                self.expectation.fulfill()
                return
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 60.0)
        
    }

}
