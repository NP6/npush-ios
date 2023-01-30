//
//  File.swift
//  
//
//  Created by bisenbrandt on 17/08/2022.
//

import Foundation


public class Notification : Identifiable, Codable {
    
    public var title: String;
    
    public var body: String;
    
    public var deeplink: String;
}
