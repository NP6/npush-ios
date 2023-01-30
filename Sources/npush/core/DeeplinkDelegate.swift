//
//  File.swift
//  
//
//  Created by bisenbrandt on 13/01/2023.
//

import Foundation


public protocol NPushDeeplinkDelegate : AnyObject {
    
    func handleDeeplink(deeplink: String)
    
}
