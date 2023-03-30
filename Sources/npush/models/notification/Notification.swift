//
//  File.swift
//  
//
//  Created by bisenbrandt on 17/08/2022.
//

import Foundation


public class Notification {
    
    public var meta: Meta;
    
    public var tracking: Tracking;
    
    public var render: Render;
    
    public init(meta: Meta, tracking: Tracking, render: Render) {
        self.meta = meta
        self.tracking = tracking
        self.render = render
    }
    
}
