//
//  File.swift
//  
//
//  Created by bisenbrandt on 28/03/2023.
//
import Foundation

import XCTest
@testable import npush

class TokenRepositoryMock: TokenRepository {
    private var getCount = 0
    private var addCount = 0
    private var existCount = 0
    
    var getMock: (() -> String?)?
    var addMock: ((String) -> String)?
    var existMock: (() -> Bool)?
    
    override func get() -> String? {
        getCount += 1
        return getMock?()
    }
    
    override func add(element: String) -> String {
        addCount += 1
        return addMock?(element) ?? element
    }
    
    override func exist() -> Bool {
        existCount += 1
        return existMock?() ?? false
    }
    
    func resetCount() {
        getCount = 0
        addCount = 0
        existCount = 0
    }
    
    func getGetCount() -> Int {
        return getCount
    }
    
    func getAddCount() -> Int {
        return addCount
    }
    
    func getExistCount() -> Int {
        return existCount
    }
}
