//
//  File.swift
//  
//
//  Created by bisenbrandt on 21/09/2022.
//

import Foundation



public class Logger {
    
    private var label: String;
    
    public init(label: String) {
        self.label = label
    }
    
    public func info(_ message: String) -> Void {
        print("\(self.label) INFO : \(message)")
    }
    
    public func error(_ message: String) -> Void {
        print("\(self.label) ERROR : \(message)")
    }

}
