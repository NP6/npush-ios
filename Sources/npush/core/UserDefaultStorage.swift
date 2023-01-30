//
//  File.swift
//  
//
//  Created by bisenbrandt on 20/06/2022.
//

import Foundation

public class UserDefaultStorage : LocalStorageAdapter {
    
    private var userDefault: UserDefaults;
    
    init(namespace: String) {
        self.userDefault = UserDefaults.init(suiteName: namespace) ?? UserDefaults.standard
    }
    
    public func get(key: String) -> String {
        return userDefault.string(forKey: key) ?? ""
    }
    
    public func put(key: String, value: String) {
        userDefault.set(value, forKey: key)
    }
    
    public func exist(key: String) -> Bool {
        return userDefault.string(forKey: key) != nil
    }
    
    public func remove(key: String) {
        userDefault.removeObject(forKey: key)
    }
    
}
