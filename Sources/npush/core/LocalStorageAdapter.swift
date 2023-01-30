//
//  File.swift
//  
//
//  Created by bisenbrandt on 20/06/2022.
//

import Foundation


public protocol LocalStorageAdapter {
    
    
    func get(key: String) -> String
    
    func put(key: String, value: String)
    
    func remove(key: String)
    
    func exist(key: String) -> Bool
        
}
