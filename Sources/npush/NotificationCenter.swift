//
//  File.swift
//  
//
//  Created by bisenbrandt on 22/03/2023.
//

import Foundation
import UserNotifications
import UIKit

public class NPNotificationCenter {
    
    public var logger: Logger = ConsoleLogger();
     
    
    public var interactionApi: InteractionApi;
    
    
    public static let NOTIFICATION_DEFAULT_CATEGORY = "Default_Notification_Category"

    public enum NotificationError : Error {
        case InvalidNotification
        case UnknowNotificationAction
    }
    
    public static func initialize() -> NPNotificationCenter {
        
        let interactionApi = InteractionApi.create();
        
        return NPNotificationCenter(interactionApi)
    }
    
    public init(_ interactionApi: InteractionApi) {
        self.interactionApi = interactionApi;
    }
        
    public func parse(_ userInfo : [AnyHashable : Any]) throws -> Notification {
        
        let tracking = try parseTracking(userInfo: userInfo)
        
        let meta = try parseMeta(userInfo: userInfo)
        
        let render = try parseRender(userInfo: userInfo)
        
        return Notification(
            meta: meta,
            tracking: tracking,
            render: render
        )
    }
    
    @available(iOS 10.0, *)
    public func handle(
        notification: Notification,
        response: UNNotificationResponse,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        do {
            let action =  try getAction(notification: notification, response: response)
            
            if (action is RedirectionAction) {
                
                let redirection = action as! RedirectionAction

                launchDeeplink(deeplink: redirection.deeplink)
            }
            
            self.interactionApi.get(action.radical, action.value, completion: completion)

        } catch {
            completion(.failure(error))
        }
    }
    
    @available(iOS 10.0, *)
    public func launchDeeplink(deeplink: String) {
        
        if (NPush.instance.deeplinkDelegate != nil) {
            
            NPush.instance.deeplinkDelegate?.handleDeeplink(deeplink: deeplink);
            
            return;
        }
        
        guard let url = URL(string: deeplink) else {
            self.logger.error("Failed to parse deeplink \(deeplink)")
            return;
        }
        
        UIApplication.shared.open(url, options: [:]) { result in
            if (result == false) {
                self.logger.error("Failed to launch deeplink \(deeplink)")
                return;
            }
        }
    }
    
    @available(iOS 10.0, *)
    public func handle(
        notification: Notification,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        
        let current = UNUserNotificationCenter.current()

        current.getNotificationSettings { settings in
            switch(settings.authorizationStatus) {
                
                case .authorized:
                    let impression = ImpressionAction(
                        value: notification.tracking.impression,
                        radical: notification.tracking.radical
                    )
                    
                    self.interactionApi.get(impression.radical, impression.value, completion: completion)

            case .denied:
                let optout = OptoutAction(
                    value: notification.tracking.optout.global,
                    radical: notification.tracking.radical
                )
                
                self.interactionApi.get(optout.radical, optout.value, completion: completion)
            case .ephemeral:
                break;
            case .notDetermined:
                break;
            case .provisional:
                break;
            @unknown default:
                break;
            }
        }
    }
    
    @available(iOS 10.0, *)
    public func getAction(
        notification: Notification,
        response: UNNotificationResponse
    ) throws -> TrackingAction {
        
        switch(response.actionIdentifier) {
            
        case UNNotificationDefaultActionIdentifier:
            return RedirectionAction(
                    value: notification.tracking.redirection,
                    radical: notification.tracking.radical,
                    deeplink: notification.meta.redirection
                )

        case UNNotificationDismissActionIdentifier:
            return DismissAction(
                    value: notification.tracking.dismiss,
                    radical: notification.tracking.radical
                )
            
        default:
            throw NotificationError.UnknowNotificationAction
            
        }
    }

    @available(iOS 10.0, *)
    public static func createDefaultCategory(_ name: String) {
        let defaultCategory = UNNotificationCategory(
            identifier: name,
            actions: [],
            intentIdentifiers: [],
            options: .customDismissAction
        )
        UNUserNotificationCenter.current().setNotificationCategories([defaultCategory])
    }

}



extension NPNotificationCenter {
    
    
    public func parseMeta(userInfo: [AnyHashable : Any]) throws -> Meta {
        
        guard let meta = userInfo["meta"] as? [AnyHashable : Any] else {
            throw NotificationError.InvalidNotification
        }
        
        let json = try JSONSerialization.data(withJSONObject: meta, options: .prettyPrinted)
        
        return try JSONDecoder().decode(Meta.self, from: json)
    }
    
    public func parseRender(userInfo: [AnyHashable : Any]) throws -> Render {
        
        guard let render = userInfo["render"] as? [AnyHashable : Any] else {
            throw NotificationError.InvalidNotification
        }
        
        let json = try JSONSerialization.data(withJSONObject: render, options: .prettyPrinted)
        
        return try JSONDecoder().decode(Render.self, from: json)
    }
    
    
    public func parseTracking(userInfo: [AnyHashable : Any]) throws -> Tracking {
        
        guard let tracking = userInfo["tracking"] as? [AnyHashable : Any] else {
            throw NotificationError.InvalidNotification
        }
        
        let json = try JSONSerialization.data(withJSONObject: tracking, options: .prettyPrinted)
        
        return try JSONDecoder().decode(Tracking.self, from: json)
    }
    
    
}
