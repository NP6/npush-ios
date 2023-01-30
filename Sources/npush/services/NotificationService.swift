//
//  File.swift
//  
//
//  Created by bisenbrandt on 19/08/2022.
//

import Foundation
import UserNotifications
import UIKit

@available(iOS 10.0, *)
public class NotificationService {
    
    public enum NotificationError: Error {
        case InvalidNotificationModel
        case FailedLaunchDeeplink
    }
    
    public enum NotificationResult {
        case success(UNNotificationResponse)
        case failed(Error)
    }
    
    public enum DeeplinkResult {
        case success
        case failed(Error)
    }
    
    public static func createDefaultCategory(_ name: String) ->  UNNotificationCategory {
        return UNNotificationCategory(identifier: name,
            actions: [],
            intentIdentifiers: [],
            options: .customDismissAction)
    }
    
    public static func getDeeplink(_ userInfo : [AnyHashable : Any]) throws -> String {
        
        guard  let meta = userInfo["meta"] as? [AnyHashable : Any] else {
            throw NotificationError.InvalidNotificationModel
        }
        
        guard let deeplink = meta["redirection"] as? String else {
            throw NotificationError.InvalidNotificationModel
        }
        
        return deeplink;
    }
    
    public static func launchDeeplink(_ userInfo : [AnyHashable : Any], withCompletionHandler completionHandler:  @escaping (DeeplinkResult) -> Void ) -> Void{
        do {
            
            let deeplink = try getDeeplink(userInfo)
            
            if (NPush.instance.deeplinkDelegate != nil) {
                
                NPush.instance.deeplinkDelegate?.handleDeeplink(deeplink: deeplink);
                
                completionHandler(.success)
                return;
            }
            
            let url = URL(string: deeplink)!
            
            UIApplication.shared.open(url, options: [:]) { result in
                if (result == false) {
                    completionHandler(.failed(NotificationError.FailedLaunchDeeplink))
                    return;
                }
                completionHandler(.success)
                return;
            }
        } catch {
            completionHandler(.failed(error))
        }
    }
}
