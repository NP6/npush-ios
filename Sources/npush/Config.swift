//
//  File.swift
//  
//
//  Created by bisenbrandt on 31/08/2022.
//

import Foundation

public enum ConfigError : Error {
    case NotFound
}

@objc
public class Config: NSObject {
    
    @objc
    public var identity: String;
    
    @objc
    public var application: UUID;
    
    @objc
    public init(_ identity: String, application: UUID) {
        self.identity = identity
        self.application = application
    }
}
