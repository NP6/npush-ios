//
//  File.swift
//  
//
//  Created by bisenbrandt on 20/06/2022.
//

import Foundation


public protocol ObjectFactory {
    associatedtype T
    
    func serialize (object: T) throws -> String
     
    func deserialize (object: String) throws -> T
}
