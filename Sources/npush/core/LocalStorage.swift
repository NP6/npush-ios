//
//  File.swift
//  
//
//  Created by bisenbrandt on 20/06/2022.
//

import Foundation

public class LocalStorage : LocalStorageAdapter {
    
    private var adapter: LocalStorageAdapter;
    
    init(adapter: LocalStorageAdapter) {
        self.adapter = adapter;
    }
    
    public func get(key: String) -> String {
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
    
    public func get <P: Storableobject> (storableObject: P) throws -> P.P.T {
        let value: String = adapter.get(key: storableObject.key)
                
        return try storableObject.factory.deserialize(object: value)
        
    }
    
    public func remove <P: Storableobject> (storableObject: P) {
        adapter.remove(key: storableObject.key)
    }
    
    public func exist <P: Storableobject>(storableObject: P) -> Bool {
        return adapter.exist(key: storableObject.key)
    }
    
}
