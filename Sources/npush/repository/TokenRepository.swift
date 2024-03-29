//
//  File.swift
//
//
//  Created by bisenbrandt on 27/06/2022.
//

import Foundation

public class TokenRepository : Repository {
    
    public var localStorage: LocalStorageAdapter;
    
    public let key: String = "token";
    
    public static let namespace: String = "np6.repository.token";

    public static func create() -> TokenRepository {
        let userStorage: UserDefaultStorage = UserDefaultStorage(namespace: TokenRepository.namespace)
        return TokenRepository(localStorage: userStorage)
    }
    
    public init(localStorage: LocalStorageAdapter) {
        self.localStorage = localStorage;
    }
    
    public func get() -> String? {
        return self.localStorage.get(key: self.key)
    }
    
    public func add(element: String) -> String {
        self.localStorage.put(
            key: self.key,
            value: element
        );
        return element;
    }
    
    public func exist() -> Bool {
        return self.localStorage.exist(key: self.key)
    }
    
    public func remove() {
        return self.localStorage.remove(key: self.key)
    }
}
