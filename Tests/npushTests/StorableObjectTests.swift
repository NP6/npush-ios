//
//  File.swift
//  
//
//  Created by bisenbrandt on 30/06/2022.
//

import XCTest
@testable import npush
final class StorableObjectsTests: XCTestCase {

    enum UnitTestError : Error {
        case InvalidTestContextCreation
    }
    
    func testSubscriptionStorableObjectSerializationWithValidObject() {
        let template = "{\"id\":\"5D85FD36-759A-4154-B2CA-956C7EDF75A1\",\"application\":\"FD9913AD-EEF4-424A-A138-9AA59A2B2C6F\",\"linked\":{\"type\":\"id\",\"value\":\"000E45T\"},\"gateway\":{\"token\":\"faketoken\",\"type\":\"apns\"},\"culture\":\"FR_fr\"}"
                
        let storableObject = SubscriptionStorageObject.init(
            key: "test-storable",
            factory: SubscriptionFactory.init()
        )
        
        let subscription = Subscription(
            id: UUID(uuidString: "5D85FD36-759A-4154-B2CA-956C7EDF75A1") ?? UUID(),
            application: UUID(uuidString: "FD9913AD-EEF4-424A-A138-9AA59A2B2C6F")  ?? UUID(),
            gateway: Gateway(token: "faketoken"),
            linked: Linked(type: "id", identifier: "efkezf")
        )

        let str = storableObject.factory.serialize(object: subscription)
        
        XCTAssertEqual(str, template)
    }
    
    func testSubscriptionStorableObjectDeserializationWithValidObject() {
        let original = "{\"id\":\"5D85FD36-759A-4154-B2CA-956C7EDF75A1\",\"application\":\"FD9913AD-EEF4-424A-A138-9AA59A2B2C6F\",\"linked\":{\"type\":\"id\",\"value\":\"000E45T\"},\"gateway\":{\"token\":\"faketoken\",\"type\":\"apns\"},\"culture\":\"FR_fr\"}"
                
        let storableObject = SubscriptionStorageObject.init(
            key: "test-storable",
            factory: SubscriptionFactory.init()
        )
        
        let comparative = Subscription(
            id: UUID(uuidString: "5D85FD36-759A-4154-B2CA-956C7EDF75A1") ?? UUID(),
            application: UUID(uuidString: "FD9913AD-EEF4-424A-A138-9AA59A2B2C6F")  ?? UUID(),
            gateway: Gateway(token: "faketoken"),
            linked: Linked(type: "id", identifier: "efkezf")
        )
        
        let subscription = try! storableObject.factory.deserialize(object: original)
        
        XCTAssertEqual(subscription.id, comparative.id)
        XCTAssertEqual(subscription.gateway.token, comparative.gateway.token)
        XCTAssertEqual(subscription.application, comparative.application)
        XCTAssertEqual(subscription.linked.value, comparative.linked.value)

    }
    
    
    func testSubscriptionStorableObjectDeserializationWithInvalidObject() {
        let original = "definitly not a json"
                
        let storableObject = SubscriptionStorageObject.init(
            key: "identifier-test-storable",
            factory: SubscriptionFactory.init()
        )
        
        XCTAssertThrowsError(try storableObject.factory.deserialize(object: original))
    }
    
    
    func testIdentifierStorableObjectSerializationWithValidObject() {
        let template = "C3F9D68D-08AF-4080-B887-7D029566DE2A"
        
        let storableObject = IdentifierStorageObject.init(
            key: "identifier-test-storable",
            factory: IdentifierFactory.init()
        )

        let result = storableObject.factory.serialize(object: UUID(uuidString: template) ?? UUID())
        
        XCTAssertEqual(result, template)
    }
    
    func testIdentifierStorableObjectDeserializationWithValidObject() {
        let original = "C3F9D68D-08AF-4080-B887-7D029566DE2A"
                
        let storableObject = IdentifierStorageObject.init(
            key: "identifier-test-storable",
            factory: IdentifierFactory.init()
        )
        
        let uuid = try! storableObject.factory.deserialize(object: original)
        XCTAssertEqual(uuid.uuidString, original)

    }
    
    
    func testIdenfitierStorableObjectDeserializationWithInvalidObject() {
        let invalid = "definitly not a uuid"
                
        let storableObject = IdentifierStorageObject.init(
            key: "identifier-test-storable",
            factory: IdentifierFactory.init()
        )
        
        XCTAssertThrowsError(try storableObject.factory.deserialize(object: invalid))
    }
}
