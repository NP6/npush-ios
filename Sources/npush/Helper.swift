//
//  File.swift
//  
//
//  Created by bisenbrandt on 27/06/2022.
//

import Foundation




public struct Helper {
    
    public static func parseTokenData(deviceToken: Data) -> String {
        return deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    }
}
