//
//  File.swift
//  
//
//  Created by bisenbrandt on 23/03/2023.
//

import Foundation



public class Action {
    
    public class InternalAction<T> : Action {
        
        public var value: T
        
        public init(value: T) {
            self.value = value
        }
    }
}


public class TrackingAction : Action.InternalAction<String> {
    
    public var radical: String;
    
    public init(value: String, radical: String) {
        self.radical = radical
        super.init(value: value)
    }
}

public class RedirectionAction : TrackingAction {
    
    var deeplink: String;
    
    public init(value: String, radical: String, deeplink: String) {
        
        self.deeplink = deeplink
        super.init(value: value, radical: radical)
    }
}

public class DismissAction : TrackingAction {}

public class ImpressionAction : TrackingAction {}

