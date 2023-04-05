//
//  File.swift
//  
//
//  Created by bisenbrandt on 29/03/2023.
//

import Foundation


import Foundation
import XCTest
@testable import npush


final class NotificationCenterTests: XCTestCase {
    
    let config = Config(identity: "MCOM032", application: UUID())

    override func setUp() {
        UserDefaults.resetStandardUserDefaults()
    }
    
    override func tearDown() {
        UserDefaults.resetStandardUserDefaults()
    }
    
    
    public func testParsingMetaFromValidInput()  {
        do {
            let data: [AnyHashable : Any] = [
                "meta": [
                    "notification": 205,
                    "version": "e211fc95-108f-45d3-9378-78acda9e7b00",
                    "application": "c5d6993f-7e81-4039-8755-5b82694bf473",
                    "stamp": [
                        "time": 168000509,
                        "id": "533fe44a-45f3-4853-93f8-eabd4487a13c",
                        "thread": "4a8d8d85-9445-4734-928c-d2a165ec1202",
                        "set": "cc9a9d2d-1686-4c98-be0c-70c9a84ac3e2"
                    ],
                    "redirection": "app://npush/product2"
                ]
            ]
            
            let meta = try NPNotificationCenter.initialize().parseMeta(userInfo: data)
            
            XCTAssertEqual(meta.redirection, "app://npush/product2")
            XCTAssertEqual(meta.notification, 205)

        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    
    public func testParsingMetaFromInvalidValidInput()  {
        do {
            let data: [AnyHashable : Any] = [
                "meta": [
                    "redirection": "app://npush/product2"
                ]
            ]
            
            _ = try NPNotificationCenter.initialize().parseMeta(userInfo: data)
            
            XCTFail("Unexpected success")

        } catch {
            guard let error = error as? DecodingError else {
                XCTFail("Unexpected error: \(error)")
                return
            }
            XCTAssert(true)
        }
    }
    
    public func testParsingTrackingFromValidInput()  {
        do {
            let data: [AnyHashable : Any] = [
                "tracking": [
                    "radical": "https://np6-tracking/hit/MCOM/032/gz/-VYJaJmpojUweyhpUXrdQgQp-3H-QM21OVbD4k-/link/",
                    "impression": "NrN2DOxRend-jubzj5PDwoYI0fQRAmLaPrhbMPiQtv5b2mxicJnh6A06n_w_pWoZmMqfaM_5d8Uc52bMzEW1Lx0ZrbPP",
                    "redirection": "sJJkieygww83qrI1le62DPxeVYc10QKxTcEqaTSlvltmKFBg_cq7Vc7Stl--b-UcrZlnWYt6RUYUvSuoVGFoKEnHsMpe-X5Rscu8lUJFSEZXt0ibKZYgjyk1Ajf62_jzbBRYR-aByQ",
                    "dismiss": "5XzOMVQhdSF5mHK7tnTQrs8Ca5agyOa9XP0q37BcOxO_XfiqUfpNiSN6N7wMm8MTrY8D_555h7LeNDvPER-aItMJ",
                    "optout": [
                        "global": "px8OK8PaZpOl1JCO3wbPtDwx0ZD4GCBKXwxvfQtxYFRGxeJfv46A_qx8xkcOl-pmDvOjhxBs_B02zgw",
                        "channel": "aA4NtFhpZS8JHmzGfxxsTwJzDNmDWnU8rPmCKMeJ_zAy0W23amGa0sjh0YgpsXfuo"
                    ]
                ]
            ]
            
            let tracking = try NPNotificationCenter.initialize().parseTracking(userInfo: data)
            
            XCTAssertEqual(tracking.radical, "https://np6-tracking/hit/MCOM/032/gz/-VYJaJmpojUweyhpUXrdQgQp-3H-QM21OVbD4k-/link/")
            XCTAssertEqual(tracking.impression, "NrN2DOxRend-jubzj5PDwoYI0fQRAmLaPrhbMPiQtv5b2mxicJnh6A06n_w_pWoZmMqfaM_5d8Uc52bMzEW1Lx0ZrbPP")

        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    public func testParsingTrackingFromInvalidInput()  {
        do {
            let data: [AnyHashable : Any] = [
                "tracking": [
                    "radical": "https://np6-tracking/hit/MCOM/032/gz/-VYJaJmpojUweyhpUXrdQgQp-3H-QM21OVbD4k-/link/",
                    "impression": "NrN2DOxRend-jubzj5PDwoYI0fQRAmLaPrhbMPiQtv5b2mxicJnh6A06n_w_pWoZmMqfaM_5d8Uc52bMzEW1Lx0ZrbPP",
                ]
            ]
            
            _ = try NPNotificationCenter.initialize().parseTracking(userInfo: data)
            
            XCTFail("Unexpected success")

        } catch {
            guard let error = error as? DecodingError else {
                XCTFail("Unexpected error: \(error)")
                return
            }
            XCTAssert(true)
        }
    }
    
    public func testParsingRenderFromValidInput()  {
        do {
            let data: [AnyHashable : Any] = [
                "render": [
                    "title": "world",
                    "body": "hello"
                ]
            ]
            
            let render = try NPNotificationCenter.initialize().parseRender(userInfo: data)
            
            XCTAssertEqual(render.title, "world")
            XCTAssertEqual(render.body, "hello")

        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    public func testParsingRenderFromInvalidInput()  {
        do {
            let data: [AnyHashable : Any] = [
                "render": [
                    "body": "hello"
                ]
            ]
                        
            XCTAssertThrowsError(try NPNotificationCenter.initialize().parseRender(userInfo: data)) { error in
                XCTAssert(true)
            }

        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    
    @available(iOS 10.0, *)
    public func testParsingNotificationResponseWithDefaultAction() {
        do {
            let data: [AnyHashable : Any] = [
                "meta": [
                    "notification": 205,
                    "version": "e211fc95-108f-45d3-9378-78acda9e7b00",
                    "application": "c5d6993f-7e81-4039-8755-5b82694bf473",
                    "stamp": [
                        "time": 1680450509,
                        "id": "533fe44a-45f3-4853-93f8-eabd4487a13c",
                        "thread": "4a8d8d85-9445-4734-928c-d2a165ec1202",
                        "set": "cc9a9d2d-1686-4c98-be0c-70c9a84ac3e2"
                    ],
                    "redirection": "app://npush/product2"
                ],
                "render": [
                    "title": "world",
                    "body": "hello"
                ],
                "tracking": [
                    "radical": "https://np6-tracking.com/hit/MCOM/032/gz/-VYJaJmpojUweyhpUXrdQgQp-3H-QM21OVbD4k-/link/",
                    "impression": "NrN2DOxRend-jubzj5PDwoYI0fQRAmLaPrhbMPiQtv5b2mxicJnh6A06n_w_pWoZmMqfaM_5d8Uc52bMzEW1Lx0ZrbPP",
                    "redirection": "sJJkieygww83qrI1le62DPxeVYc10QKxTcEqaTSlvltmKFBg_cq7Vc7Stl",
                    "dismiss": "5XzOMVQhdSF5mHK7tnTQrs8Ca5agyOa9XP0q37BcOxO_XfiqUfpNiSN6N7wMm8MTrY8D_555h7LeNDvPER-aItMJ",
                    "optout": [
                        "global": "px8OK8PaZpOl1JCO3wbPtDwx0ZD4GCBKXwxvfQtxYFRGxeJfv46A_qx8xkcOl-pmDvOjhxBs_B02zgw",
                        "channel": "aA4NtFhpZS8JHmzGfxxsTwJzDNmDWnU8rPmCKMeJ_zAy0W23amGa0sjh0YgpsXfuo"
                    ]
                ]
            ]
            
            let response = try UNNotificationResponse.with(userInfo: data, actionIdentifier: UNNotificationDefaultActionIdentifier)
            
            let notification = try NPNotificationCenter.initialize().parse(data)
            
            let action = try NPNotificationCenter.initialize().getAction(notification: notification, response: response)
            
            
            guard let redirectionAction = action as? RedirectionAction else {
                XCTFail("Unexpected action type")
                return;
            }
            
            XCTAssert(action is RedirectionAction)
            XCTAssertEqual(redirectionAction.deeplink, "app://npush/product2")
            XCTAssertEqual(redirectionAction.radical,  "https://np6-tracking.com/hit/MCOM/032/gz/-VYJaJmpojUweyhpUXrdQgQp-3H-QM21OVbD4k-/link/")
            XCTAssertEqual(redirectionAction.value,  "sJJkieygww83qrI1le62DPxeVYc10QKxTcEqaTSlvltmKFBg_cq7Vc7Stl")

        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    
    }

    
    @available(iOS 10.0, *)
    public func testParsingNotificationResponseWithDismissAction() {
        do {
            let data: [AnyHashable : Any] = [
                "meta": [
                    "notification": 205,
                    "version": "e211fc95-108f-45d3-9378-78acda9e7b00",
                    "application": "c5d6993f-7e81-4039-8755-5b82694bf473",
                    "stamp": [
                        "time": 1680094759,
                        "id": "533fe44a-45f3-4853-93f8-eabd4487a13c",
                        "thread": "4a8d8d85-9445-4734-928c-d2a165ec1202",
                        "set": "cc9a9d2d-1686-4c98-be0c-70c9a84ac3e2"
                    ],
                    "redirection": "app://npush/product2"
                ],
                "render": [
                    "title": "world",
                    "body": "hello"
                ],
                "tracking": [
                    "radical": "https://np6-tracking.com/hit/MCOM/032/gz/-VYJaJmpojUweyhpUXrdQgQp-3H-QM21OVbD4k-/link/",
                    "impression": "NrN2DOxRend-jubzj5PDwoYI0fQRAmLaPrhbMPiQtv5b2mxicJnh6A06n_w_pWoZmMqfaM_5d8Uc52bMzEW1Lx0ZrbPP",
                    "redirection": "sJJkieygww83qrI1le62DPxeVYc10QKxTcEqaTSlvltmKFBg_cq7Vc7Stl",
                    "dismiss": "5XzOMVQhdSF5mHK7tnTQrs8Ca5agyOa9XP0q37BcOxO_XfiqUfpNiSN6N7wMm8MTrY8D_555h7LeNDvPER-aItMJ",
                    "optout": [
                        "global": "px8OK8PaZpOl1JCO3wbPtDwx0ZD4GCBKXwxvfQtxYFRGxeJfv46A_qx8xkcOl-pmDvOjhxBs_B02zgw",
                        "channel": "aA4NtFhpZS8JHmzGfxxsTwJzDNmDWnU8rPmCKMeJ_zAy0W23amGa0sjh0YgpsXfuo"
                    ]
                ]
            ]
            
            let response = try UNNotificationResponse.with(userInfo: data, actionIdentifier: UNNotificationDismissActionIdentifier)
            
            let notification = try NPNotificationCenter.initialize().parse(data)
            
            let action = try NPNotificationCenter.initialize().getAction(notification: notification, response: response)
            
            
            guard let dismissAction = action as? DismissAction else {
                XCTFail("Unexpected action type")
                return;
            }
            
            XCTAssert(action is DismissAction)
            XCTAssertEqual(dismissAction.radical,  "https://np6-tracking.com/hit/MCOM/032/gz/-VYJaJmpojUweyhpUXrdQgQp-3H-QM21OVbD4k-/link/")
            XCTAssertEqual(dismissAction.value,  "5XzOMVQhdSF5mHK7tnTQrs8Ca5agyOa9XP0q37BcOxO_XfiqUfpNiSN6N7wMm8MTrY8D_555h7LeNDvPER-aItMJ")

        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    @available(iOS 10.0, *)
    public func testParsingNotificationResponseWithUnknowAction() {
        do {
            let data: [AnyHashable : Any] = [
                "meta": [
                    "notification": 205,
                    "version": "e211fc95-108f-45d3-9378-78acda9e7b00",
                    "application": "c5d6993f-7e81-4039-8755-5b82694bf473",
                    "stamp": [
                        "time": 168009409,
                        "id": "533fe44a-45f3-4853-93f8-eabd4487a13c",
                        "thread": "4a8d8d85-9445-4734-928c-d2a165ec1202",
                        "set": "cc9a9d2d-1686-4c98-be0c-70c9a84ac3e2"
                    ],
                    "redirection": "app://npush/product2"
                ],
                "render": [
                    "title": "world",
                    "body": "hello"
                ],
                "tracking": [
                    "radical": "https://np6-tracking.com/hit/MCOM/032/gz/-VYJaJmpojUweyhpUXrdQgQp-3H-QM21OVbD4k-/link/",
                    "impression": "NrN2DOxRend-jubzj5PDwoYI0fQRAmLaPrhbMPiQtv5b2mxicJnh6A06n_w_pWoZmMqfaM_5d8Uc52bMzEW1Lx0ZrbPP",
                    "redirection": "sJJkieygww83qrI1le62DPxeVYc10QKxTcEqaTSlvltmKFBg_cq7Vc7Stl",
                    "dismiss": "5XzOMVQhdSF5mHK7tnTQrs8Ca5agyOa9XP0q37BcOxO_XfiqUfpNiSN6N7wMm8MTrY8D_555h7LeNDvPER-aItMJ",
                    "optout": [
                        "global": "px8OK8PaZpOl1JCO3wbPtDwx0ZD4GCBKXwxvfQtxYFRGxeJfv46A_qx8xkcOl-pmDvOjhxBs_B02zgw",
                        "channel": "aA4NtFhpZS8JHmzGfxxsTwJzDNmDWnU8rPmCKMeJ_zAy0W23amGa0sjh0YgpsXfuo"
                    ]
                ]
            ]
            
            let response = try UNNotificationResponse.with(userInfo: data, actionIdentifier: "unknow")
            
            let notification = try NPNotificationCenter.initialize().parse(data)
            
            
            XCTAssertThrowsError(try NPNotificationCenter.initialize().getAction(notification: notification, response: response)) { error in
                XCTAssertEqual(error as! NPNotificationCenter.NotificationError, NPNotificationCenter.NotificationError.UnknowNotificationAction)
            }
            
        } catch {
            XCTFail("unexpected exception")
        }
    }

}
