//
//  Subscription.swift
//  push
//
//  Created by bisenbrandt on 01/06/2022.
//

import Foundation

public class Subscription: Identifiable, Codable {
    public var id: UUID
    public var application: UUID
    public var gateway: Gateway
    public var linked: Linked
    public var culture: String
    
    init(id: UUID = UUID(), application: UUID, gateway: Gateway, linked: Linked) {
        self.id = id
        self.application = application
        self.gateway = gateway
        self.linked = linked
        self.culture = "FR_fr"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id;
        case application;
        case gateway;
        case linked;
        case culture;
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        application = try container.decode(UUID.self, forKey: .application)
        gateway = try container.decode(Gateway.self, forKey: .gateway)
        linked = try container.decode(Linked.self, forKey: .linked)
        culture = try container.decode(String.self, forKey: .culture)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(application, forKey: .application)
        try container.encode(gateway, forKey: .gateway)
        try container.encode(linked, forKey: .linked)
        try container.encode(culture, forKey: .culture)

    }
}
