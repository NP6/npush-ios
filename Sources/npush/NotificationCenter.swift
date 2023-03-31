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

    public enum NotificationError : Error {
        case InvalidNotification
        case UnknowNotificationAction
    }
        
    public static func parse(_ userInfo : [AnyHashable : Any]) throws -> Notification {
        
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
    public static func handle(
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
            
            InteractionApi.create().get(action.radical, action.value, completion: completion)

        } catch {
            completion(.failure(error))
        }
    }
    
    @available(iOS 10.0, *)
    public static func launchDeeplink(deeplink: String) {
        
        if (NPush.instance.deeplinkDelegate != nil) {
            
            NPush.instance.deeplinkDelegate?.handleDeeplink(deeplink: deeplink);
            
            return;
        }
        
        guard let url = URL(string: deeplink) else {
            Logger.error("Failed to parse deeplink \(deeplink)")
            return;
        }
        
        UIApplication.shared.open(url, options: [:]) { result in
            if (result == false) {
                Logger.error("Failed to launch deeplink \(deeplink)")
                return;
            }
        }
    }
    
    @available(iOS 10.0, *)
    public static func handle(
        notification: Notification,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        
        let impression =  ImpressionAction(
            value: notification.tracking.impression,
            radical: notification.tracking.radical
        )
        
        InteractionApi.create().get(impression.radical, impression.value, completion: completion)
    }
    
    @available(iOS 10.0, *)
    public static func getAction(
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
    
    
    public static func parseMeta(userInfo: [AnyHashable : Any]) throws -> Meta {
        
        guard let meta = userInfo["meta"] as? [AnyHashable : Any] else {
            throw NotificationError.InvalidNotification
        }
        
        let json = try JSONSerialization.data(withJSONObject: meta, options: .prettyPrinted)
        
        return try JSONDecoder().decode(Meta.self, from: json)
    }
    
    public static func parseRender(userInfo: [AnyHashable : Any]) throws -> Render {
        
        guard let render = userInfo["render"] as? [AnyHashable : Any] else {
            throw NotificationError.InvalidNotification
        }
        
        let json = try JSONSerialization.data(withJSONObject: render, options: .prettyPrinted)
        
        return try JSONDecoder().decode(Render.self, from: json)
    }
    
    
    public static func parseTracking(userInfo: [AnyHashable : Any]) throws -> Tracking {
        
        guard let tracking = userInfo["tracking"] as? [AnyHashable : Any] else {
            throw NotificationError.InvalidNotification
        }
        
        let json = try JSONSerialization.data(withJSONObject: tracking, options: .prettyPrinted)
        
        return try JSONDecoder().decode(Tracking.self, from: json)
    }
    
    
}
