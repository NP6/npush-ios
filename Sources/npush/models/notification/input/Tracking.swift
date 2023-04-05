//
//  File.swift
//  
//
//  Created by bisenbrandt on 17/08/2022.
//

import Foundation

public class Optout : Identifiable, Codable {
    
    
    public var global: String;
    
    
    public init(global: String) {
        self.global = global;
    }
    
    private enum CodingKeys: String, CodingKey {
        case global;
    }
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        global = try container.decode(String.self, forKey: .global)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(global, forKey: .global)
    }
}

public class Tracking : Identifiable, Codable {
    
    public var dismiss: String;
    
    public var impression: String;
    
    public var redirection: String;
    
    public var radical: String;
    
    public var optout: Optout;
    
    
    public init(dismiss: String, impression: String, redirection: String, radical: String, optout: Optout) {
        self.dismiss = dismiss
        self.impression = impression
        self.redirection = redirection
        self.radical = radical
        self.optout = optout
    }
    
    private enum CodingKeys: String, CodingKey {
        case dismiss;
        case impression;
        case redirection ;
        case radical;
        case optout;
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dismiss = try container.decode(String.self, forKey: .dismiss)
        impression = try container.decode(String.self, forKey: .impression)
        redirection = try container.decode(String.self, forKey: .redirection)
        radical = try container.decode(String.self, forKey: .radical)
        optout = try container.decode(Optout.self, forKey: .optout)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dismiss, forKey: .dismiss)
        try container.encode(impression, forKey: .impression)
        try container.encode(redirection, forKey: .redirection)
        try container.encode(radical, forKey: .radical)
        try container.encode(optout, forKey: .optout)

    }

    
}
