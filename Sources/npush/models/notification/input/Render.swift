//
//  File.swift
//  
//
//  Created by bisenbrandt on 22/03/2023.
//

import Foundation


public class Render : Identifiable, Codable{
    
    public var title: String;
    
    public var body: String;
    
    public init(
        title: String,
        body: String
    ) {
        self.title = title
        self.body = body
    }
    
    private enum CodingKeys: String, CodingKey {
        case title
        case body
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(body, forKey: .body)
    }

}
