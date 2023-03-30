//
//  File.swift
//  
//
//  Created by bisenbrandt on 20/06/2022.
//

import Foundation

public class LocalStorage : LocalStorageAdapter {
    
    private var adapter: LocalStorageAdapter;
    
    public init(adapter: LocalStorageAdapter) {
        self.adapter = adapter;
    }
    
    public func get(key: String) -> String? {
        return adapter.get(key: key)
    }
    
    public func put(key: String, value: String) {
        return adapter.put(key: key, value: value)
    }
    
    public func remove(key: String) {
        return remove(key: key)
    }
    
    public func exist(key: String) -> Bool {
        return adapter.exist(key: key)
    }
    
}
