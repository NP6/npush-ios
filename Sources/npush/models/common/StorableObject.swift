//
//  File.swift
//  
//
//  Created by bisenbrandt on 20/06/2022.
//

import Foundation


public protocol Storableobject  {
    
    associatedtype P : ObjectFactory
    
    var key: String { get }
    
    var factory: P { get }
    
    init(key: String, factory: P)

}

