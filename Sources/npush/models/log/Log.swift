//
//  File.swift
//  
//
//  Created by bisenbrandt on 31/03/2023.
//

import Foundation

public enum LogType : String, RawRepresentable, Codable {
    
    case Info
    case Warning
    case Error
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .Info:
            return "info"
        case .Error:
            return "error"
        case .Warning:
            return "warning"
        }
    }
    
    public init?(rawValue: RawValue) {
          switch rawValue {
              case "info":
                self = .Info
              case "error":
                  self = .Error
                case "warning":
                  self = .Warning
              default:
                  return nil
          }
      }

}


public class Log<T> : Codable where T : Codable {
    
    
    public var type: LogType
    
    public var id: UUID = UUID()
    
    public var timestamp: Double = NSDate().timeIntervalSince1970
    
    public var value: T;
    
    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case timestamp
        case value
    }
    public init(type: LogType, value: T) {
        self.type = type
        self.id = UUID()
        self.timestamp = NSDate().timeIntervalSince1970
        self.value = value
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(LogType.self, forKey: .type)
        id = try container.decode(UUID.self, forKey: .id)
        timestamp = try container.decode(Double.self, forKey: .timestamp)
        value = try container.decode(T.self, forKey: .value)

    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(id, forKey: .id)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(value, forKey: .value)
    }

}
