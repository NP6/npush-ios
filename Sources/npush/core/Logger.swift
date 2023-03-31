//
//  File.swift
//
//
//  Created by bisenbrandt on 21/09/2022.
//

import Foundation



public class Logger {
            
    public static func info(_ message: String) -> Void {
        do {
            let log = Log<String>(type: LogType.Info, value: message)
            
            let json = try JSONEncoder().encode(log)
            
            print("\(String(decoding: json, as: UTF8.self))")
            
        } catch {
            print(error)
        }
    }
    
    public static func error(_ message: String) -> Void {
        do {
            let log = Log<String>(type: LogType.Info, value: message)
            
            let json = try JSONEncoder().encode(log)
            
            print("\(String(decoding: json, as: UTF8.self))")
        } catch {}
    }

}
