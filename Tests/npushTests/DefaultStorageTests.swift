import XCTest
@testable import npush

final class DefaultStorageTests: XCTestCase {
        
    var defaultUserDefaultStorage = UserDefaultStorage.init(namespace: "test")
        
    override func setUp() {
        UserDefaults.resetStandardUserDefaults()
    }

    func testExistWithNonExistingKey() throws {
        let unknow = defaultUserDefaultStorage.exist(key: "unknow")
        XCTAssertEqual(unknow, false)
    }
    
    func testExistWithExistingKey() throws {
        
        let key: String = "test_key"
        let strValue: String = "test_value"

        defaultUserDefaultStorage.put(key: key, value: strValue)
        
        let know = defaultUserDefaultStorage.exist(key: key)
        XCTAssertEqual(know, true)
    
    }
    
    func testGetWithExistingKey( ) {
        let key: String = "test_get_key"
        let strValue: String = "test_get_value"
        
        defaultUserDefaultStorage.put(key: key, value: strValue)
        
        let value = defaultUserDefaultStorage.get(key: key)
        
        XCTAssertEqual(value, strValue)
    }
    
    func testGetWithNonExistingKey( ) {
        let key: String = "test_unknow_key"
            
        let value = defaultUserDefaultStorage.get(key: key)
        
    }
    
    func testRemoveExistingKey( ) {
        let key: String = "test_remove_existing_key"
        let strValue: String = "test_remove_existing_value"

        defaultUserDefaultStorage.put(key: key, value: strValue)

        
        defaultUserDefaultStorage.remove(key: key)
        
        let removed = defaultUserDefaultStorage.get(key: key)
    }
    
    

}
