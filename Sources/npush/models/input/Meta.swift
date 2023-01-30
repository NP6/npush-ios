//
//  File.swift
//  
//
//  Created by bisenbrandt on 17/08/2022.
//

import Foundation


public class Meta : Identifiable, Codable {
    
    
    public var application: UUID;
    
    public var channel: String;
    
    public var notification: Int;
    
    public var redirection: String;
    
    public var image: String;
    
    public var stamp: Stamp;
    
    
    public init(application: UUID, channel: String, notification: Int, redirection: String, image: String, stamp: Stamp ) {
        self.application = application
        self.channel = channel
        self.notification = notification
        self.redirection = redirection
        self.image = image
        self.stamp = stamp
    }
    
    private enum CodingKeys: String, CodingKey {
        case application;
        case channel;
        case notification;
        case redirection;
        case image;
        case stamp;
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        application = try container.decode(UUID.self, forKey: .application)
        channel = try container.decode(String.self, forKey: .channel)
        notification = try container.decode(Int.self, forKey: .notification)
        redirection = try container.decode(String.self, forKey: .redirection)
        image = try container.decode(String.self, forKey: .image)
        stamp = try container.decode(Stamp.self, forKey: .stamp)

    }

    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(application, forKey: .application)
        try container.encode(channel, forKey: .channel)
        try container.encode(notification, forKey: .notification)
        try container.encode(redirection, forKey: .redirection)
        try container.encode(image, forKey: .image)
        try container.encode(stamp, forKey: .stamp)
    }

    
    
    
}
