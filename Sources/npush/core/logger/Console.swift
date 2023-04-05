//
//  File.swift
//  
//
//  Created by bisenbrandt on 05/04/2023.
//

import Foundation


public class ConsoleLogger : Logger {
    
    public func info(_ message: String) -> Void {
        let log = Log<String>(type: LogType.Info, value: message)
        
        print(log.value)
        
    }
    
    public func error(_ message: String) -> Void {
        let log = Log<String>(type: LogType.Info, value: message)
        
        print(log.value)
        
    }
    
    public func warning(_ message: String) {
        let log = Log<String>(type: LogType.Warning, value: message)
        
        print(log.value)
        
    }
    
}
