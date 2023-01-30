//
//  File.swift
//  
//
//  Created by bisenbrandt on 29/08/2022.
//

import Foundation
import UIKit

public class Device : Identifiable, Codable {
    
    
    public var model: String;
    
    public var systemVersion: String;
    
    public var systemName: String;
    
    
    public init() {
        self.model = UIDevice.current.model
        self.systemVersion = UIDevice.current.systemVersion
        self.systemName = UIDevice.current.systemName
    }
    private enum CodingKeys: String, CodingKey {
        case model;
        case systemVersion;
        case systemName;
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        model = try container.decode(String.self, forKey: .model)
        systemVersion = try container.decode(String.self, forKey: .systemVersion)
        systemName = try container.decode(String.self, forKey: .systemName)

    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(model, forKey: .model)
        try container.encode(systemVersion, forKey: .systemVersion)
        try container.encode(systemName, forKey: .systemName)
    }

}

public class Telemetry: Identifiable, Codable {
    
    public var error: String
    
    public var application: UUID

    public var device: Device;
    
    public init(error: Error, application: UUID) {
        self.error = error.localizedDescription
        self.application = application
        self.device = Device()
    }
    
    private enum CodingKeys: String, CodingKey {
        case error;
        case application;
        case device;
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        error = try container.decode(String.self, forKey: .error)
        application = try container.decode(UUID.self, forKey: .application)
        device = try container.decode(Device.self, forKey: .device)

    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(error, forKey: .error)
        try container.encode(application, forKey: .application)
        try container.encode(device, forKey: .device)

    }
}
