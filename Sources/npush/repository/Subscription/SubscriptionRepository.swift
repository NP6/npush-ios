//
//  File.swift
//  
//
//  Created by bisenbrandt on 20/06/2022.
//

import Foundation

public class SubscriptionFactory : ObjectFactory {
    
    public func serialize(object: Subscription) -> String {
        let jsonData = try! JSONEncoder().encode(object)
        return String(data: jsonData, encoding: .utf8)!
    }
    
    public func deserialize(object: String) throws -> Subscription {
        let jsonData = object.data(using: .utf8)!
        return try JSONDecoder().decode(Subscription.self, from: jsonData)
    }
}

public class SubscriptionStorageObject : Storableobject {
    
    public var key: String
    
    public var factory: SubscriptionFactory

    public required init(key: String, factory: SubscriptionFactory) {
        self.key = key
        self.factory = factory
    }
}

public class SubscriptionRepository : Repository {
    
    public var localStorage: LocalStorage;
    public let storageObject: SubscriptionStorageObject
    
    init(localStorage: LocalStorage) {
        self.localStorage = localStorage
        self.storageObject = SubscriptionStorageObject.init(
            key: "subscription",
            factory: SubscriptionFactory.init()
        )
    }
    
    init(localStorage: LocalStorage, storableObject: SubscriptionStorageObject) {
        self.localStorage = localStorage
        self.storageObject = storableObject
    }

    
    public func Get() throws -> Subscription {
        return try self.localStorage.get(storableObject: self.storageObject)
    }
        
    public func Add(element: Subscription) -> Subscription {
        self.localStorage.put(
            key: self.storageObject.key,
            value: self.storageObject.factory.serialize(object: element)
        )
        return element;
    }
    
    public func Exist() -> Bool {
        return true;
    }
}
