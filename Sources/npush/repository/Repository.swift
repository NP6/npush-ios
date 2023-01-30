//
//  File.swift
//  
//
//  Created by bisenbrandt on 20/06/2022.
//

import Foundation

public protocol Repository {
    
    associatedtype T 
    
    func Get() throws -> T
    
    func Add(element: T) throws -> T
    
    func Exist() -> Bool
    
}



