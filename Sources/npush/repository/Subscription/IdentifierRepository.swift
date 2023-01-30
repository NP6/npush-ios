//
//  File.swift
//  
//
//  Created by bisenbrandt on 27/06/2022.
//

import Foundation



public class IdentifierFactory : ObjectFactory {
    
    public func serialize(object: UUID) -> String {
        return object.uuidString
    }
    
    public func deserialize(object: String) throws -> UUID {
        return try UUID.init(uuidString: object) ?? { throw IdentifierStorageObject.FactoryException.DeserializationException }()
    }
}

public class IdentifierStorageObject : Storableobject {
    
    public enum FactoryException : Error {
        case DeserializationException
        case SerializationException
    }

    
    public var key: String
    
    public var factory: IdentifierFactory

    public required init(key: String, factory: IdentifierFactory) {
        self.key = key
        self.factory = factory
    }
}

public class IdentifierRepository : Repository {
    
    private var localStorage: LocalStorage;
    public let storageObject: IdentifierStorageObject
    
    init(localStorage: LocalStorage) {
        self.localStorage = localStorage
        self.storageObject = IdentifierStorageObject.init(
            key: "subscription_identifier",
            factory: IdentifierFactory.init()
        )
    }
    
    init(localStorage: LocalStorage, storableObject: IdentifierStorageObject) {
        self.localStorage = localStorage
        self.storageObject = storableObject
        
    }

    
    public func Get() throws -> UUID {
        return try self.localStorage.get(storableObject: self.storageObject)
    }
    
    public func Add(element: UUID) -> UUID {
        self.localStorage.put(
            key: self.storageObject.key,
            value: self.storageObject.factory.serialize(object: element)
        )
        return element;
    }
    
    public func Exist() -> Bool {
        return self.localStorage.exist(key: self.storageObject.key)
    }
    
    public func remove() {
        return self.localStorage.remove(key: self.storageObject.key)
    }
}
