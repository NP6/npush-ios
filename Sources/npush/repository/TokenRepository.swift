//
//  File.swift
//
//
//  Created by bisenbrandt on 27/06/2022.
//

import Foundation



public class TokenFactory : ObjectFactory {
    
    public func serialize(object: String) -> String {
        return object
    }
    
    public func deserialize(object: String) throws -> String {
        return object
    }
}

public class TokenStorageObject : Storableobject {
    
    public enum FactoryException : Error {
        case DeserializationException
        case SerializationException
    }

    
    public var key: String
    
    public var factory: TokenFactory

    public required init(key: String, factory: TokenFactory) {
        self.key = key
        self.factory = factory
    }
}

public class TokenRepository : Repository {
    
    public var localStorage: LocalStorage;
    public let storageObject: TokenStorageObject
    
     init(localStorage: LocalStorage) {
        self.localStorage = localStorage
        self.storageObject = TokenStorageObject.init(
            key: "token",
            factory: TokenFactory.init()
        )
    }
    
    init(localStorage: LocalStorage, storableObject: TokenStorageObject) {
        self.localStorage = localStorage
        self.storageObject = storableObject
        
    }

    
    public func Get() throws -> String {
        return try self.localStorage.get(storableObject: self.storageObject)
    }
    
    public func Add(element: String) -> String {
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
