//
//  Linked.swift
//  push
//
//  Created by bisenbrandt on 01/06/2022.
//

import Foundation

@objc
public enum ContactType : Int, RawRepresentable {
    
    case HashRepresentation
    case UnicityRepresentation
    case IdRepresentation
    
    public typealias RawValue = String

    public var rawValue: RawValue {
        switch self {
            case .HashRepresentation:
                return "hash"
            case .IdRepresentation:
                return "id"
            case .UnicityRepresentation:
                return "uncity"
        }
    }
    
    public init?(rawValue: RawValue) {
          switch rawValue {
              case "hash":
                self = .HashRepresentation
              case "id":
                  self = .IdRepresentation
                case "uncity":
                  self = .UnicityRepresentation
              default:
                  return nil
          }
      }
    
    
}

public class Linked : Codable {
    
    public var type: String
    
    public var value: String
    
    init(type: String, identifier: String) {
        self.type = type
        self.value = identifier
    }
    
    private enum CodingKeys: String, CodingKey {
        case type;
        case value;
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(String.self, forKey: .value)
        type = try container.decode(String.self, forKey: .type)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(value, forKey: .value)
    }

    public static func fromContactType(_ contactType: ContactType, _ value: String) -> Linked {
        switch (contactType) {
            case .HashRepresentation:
                return Linked(type: "hash", identifier: value)
            case .IdRepresentation:
                return Linked(type: "id", identifier: value)
            case .UnicityRepresentation:
                return Linked(type: "unicity", identifier: value)
        }
    }

}

