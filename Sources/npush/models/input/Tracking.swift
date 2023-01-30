//
//  File.swift
//  
//
//  Created by bisenbrandt on 17/08/2022.
//

import Foundation



public class Tracking : Identifiable, Codable {
    
    public var dismiss: String;
    
    public var impression: String;
    
    public var redirection: String;
    
    public var radical: String;
    
    
    public init(dismiss: String, impression: String, redirection: String, radical: String) {
        self.dismiss = dismiss
        self.impression = impression
        self.redirection = redirection
        self.radical = radical
    }
    
    private enum CodingKeys: String, CodingKey {
        case dismiss;
        case impression;
        case redirection ;
        case radical;
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dismiss = try container.decode(String.self, forKey: .dismiss)
        impression = try container.decode(String.self, forKey: .impression)
        redirection = try container.decode(String.self, forKey: .redirection)
        radical = try container.decode(String.self, forKey: .radical)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dismiss, forKey: .dismiss)
        try container.encode(impression, forKey: .impression)
        try container.encode(redirection, forKey: .redirection)
        try container.encode(radical, forKey: .radical)
    }

    
}
