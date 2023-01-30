//
//  File.swift
//  
//
//  Created by bisenbrandt on 19/09/2022.
//

import Foundation

public enum DriverError : Error {
    case InvalidBaseUrl(message: String)
    case DataTaskFailure(message: String)
    case HttpRequestFailed(message: String, code: Int)
}


public class Driver {
    
    public var agency: String
    
    public var customer: String
    
    public var baseUrl: String
    
    public var session: URLSession
    
    public init(identity: String, base: String) {
        self.agency = String(identity.prefix(4))
        self.customer = String(identity.suffix(3))
        self.baseUrl = base + agency + "/" + customer
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    public init(base: String) {
        self.agency = ""
        self.customer = ""
        self.baseUrl = base
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
}
