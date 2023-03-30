//
//  File.swift
//  
//
//  Created by bisenbrandt on 21/09/2022.
//

import Foundation



public class Logger {
    
    private static var label: String = "np6-messaging"
        
    public static func info(_ message: String) -> Void {
        print("\(self.label) INFO : \(message)")
    }
    
    public static func error(_ message: String) -> Void {
        print("\(self.label) ERROR : \(message)")
    }

}
