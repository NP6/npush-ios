//
//  gateway.swift
//  push
//
//  Created by bisenbrandt on 02/06/2022.
//

import Foundation

public class Gateway: Identifiable, Codable {
    public let type = "apns"
    public var token: String

    init(token: String) {
        self.token = token
    }
    
    private enum CodingKeys: String, CodingKey {
        case token;
        case type;
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        token = try container.decode(String.self, forKey: .token)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(token, forKey: .token)
        try container.encode(type, forKey: .type)
    }
}
