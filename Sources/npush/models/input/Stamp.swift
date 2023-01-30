//
//  File.swift
//  
//
//  Created by bisenbrandt on 17/08/2022.
//

import Foundation
public class Stamp : Identifiable, Codable {
    
    
    public var id: UUID;
    
    public var thread: UUID;
    
    public var time: Int64;
    
    public var set: UUID;
    
    
    public init(id: UUID, thread: UUID, time: Int64, set: UUID) {
        self.id = id;
        self.thread = thread;
        self.time = time;
        self.set = set;
    }
    
    private enum CodingKeys: String, CodingKey {
        case id;
        case thread;
        case time;
        case set;
    }

    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        thread = try container.decode(UUID.self, forKey: .thread)
        time = try container.decode(Int64.self, forKey: .time)
        set = try container.decode(UUID.self, forKey: .set)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(thread, forKey: .thread)
        try container.encode(time, forKey: .time)
        try container.encode(set, forKey: .set)
    }

        
}
