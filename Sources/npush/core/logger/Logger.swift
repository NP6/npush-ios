//
//  File.swift
//  
//
//  Created by bisenbrandt on 21/09/2022.
//

import Foundation

public protocol Logger {
    
    func info(_ message: String)
    
    func error(_ message: String)
    
    func warning(_ message: String)
    
}
