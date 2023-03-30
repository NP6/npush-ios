//
//  File.swift
//  
//
//  Created by bisenbrandt on 20/06/2022.
//

import Foundation

public protocol Repository {
    
    associatedtype T 
    
    func get() throws -> T?
    
    func add(element: T) throws -> T
    
    func exist() -> Bool
    
}




