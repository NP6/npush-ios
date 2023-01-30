import XCTest
@testable import npush

final class LocalStorageTests: XCTestCase {
        
    var defaultUserDefaultStorage = LocalStorage.init(adapter: UserDefaultStorage.init(namespace: "test"))
        
    override func setUp() {
        UserDefaults.resetStandardUserDefaults()
    }
    
    override func tearDown() {
        UserDefaults.resetStandardUserDefaults()
    }

    func testLocalStorageExistWithNonExistingValue() throws {
        let unknow = defaultUserDefaultStorage.exist(key: "unknow")
        XCTAssertEqual(unknow, false)
    }
    
    func testDefaultStorageExistWithExistingValue() throws
    {
        let key: String = "test_key"
        let strValue: String = "test_value"

        defaultUserDefaultStorage.put(key: key, value: strValue)
        
        let know = defaultUserDefaultStorage.exist(key: key)
        XCTAssertEqual(know, true)
    }
    
    func testDefaultStorageGetExistingValue() {
        
    }
}
