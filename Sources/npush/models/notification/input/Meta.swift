//
//  File.swift
//  
//
//  Created by bisenbrandt on 17/08/2022.
//

import Foundation


public class Meta : Identifiable, Codable {
    
    
    public var application: UUID;
        
    public var notification: Int;
    
    public var redirection: String;
        
    public var stamp: Stamp;
    
    
    public init(_ application: UUID, _ notification: Int, _ redirection: String, _ stamp: Stamp ) {
        self.application = application
        self.notification = notification
        self.redirection = redirection
        self.stamp = stamp
    }
    
    private enum CodingKeys: String, CodingKey {
        case application;
        case notification;
        case redirection;
        case stamp;
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        application = try container.decode(UUID.self, forKey: .application)
        notification = try container.decode(Int.self, forKey: .notification)
        redirection = try container.decode(String.self, forKey: .redirection)
        stamp = try container.decode(Stamp.self, forKey: .stamp)

    }

    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(application, forKey: .application)
        try container.encode(notification, forKey: .notification)
        try container.encode(redirection, forKey: .redirection)
        try container.encode(stamp, forKey: .stamp)
    }

    
    
    
}
