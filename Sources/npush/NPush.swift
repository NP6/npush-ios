import Foundation
import SwiftUI
import Foundation
import UIKit


@objc
@available(iOS 10.0, *)
public class NPush: NSObject {
    
    
    public weak var deeplinkDelegate: NPushDeeplinkDelegate?;
    
    @objc
    public static let instance: NPush = NPush();
    
    private var config: Config? = nil;
        
    private override init() {}
    
    @objc
    public func initialize(config: Config) -> Void {
        
        self.config = config;

        UIApplication.shared.registerForRemoteNotifications()
        
        let defaultCategory = NotificationService.createDefaultCategory("Default_Notification_Category")
        UNUserNotificationCenter.current().setNotificationCategories([defaultCategory])
        TokenRepository
            .create()
            .add(element: "fzejfpezofejzpfojezpofjezjfpozejfpoezjfozejfpozejpfozpojze")
    }
    
    public func setContact(type: ContactType, value: String) {
        
        guard let config = self.config else {
            return;
        }
        
        let contact = Linked.fromContactType(type, value)
        
        Installation
            .create(config)
            .subscribe(contact) { result in
            switch result {
                case .success(_):
                    Logger.info("Subscription created successfully")
                    
                case .failure(let error):
                    Logger.error("Subscription creation failed \(error)")
            }
        }
    }
    
    @objc
    public func handleRegistrationToken(deviceToken: Data) {
        _ = TokenRepository
            .create()
            .add(element: deviceToken.map {
                String(format: "%02.2hhx", $0)
            }.joined())
    }
    
    
    
    @objc
    public func willPresent(_ userInfo: [AnyHashable : Any]) -> Void {
        do {
            let notification: Notification =  try NPNotificationCenter.parse(userInfo)
            
            NPNotificationCenter.handle(notification: notification, completion: { result in
                switch (result) {
                case .success():
                    Logger.info("notification action tracked successfully")
                    
                case .failure(let error):
                    Logger.error("failed to track notification action \(error.localizedDescription)")
                }
            })
        } catch {
            Logger.error("failed to track notification action \(error.localizedDescription)")
        }
    }
    
    @objc
    public func didReceive(_ response: UNNotificationResponse) {
        do {
            let notification: Notification = try NPNotificationCenter.parse(response.notification.request.content.userInfo)
            
            NPNotificationCenter.handle(notification: notification, response: response) { result in
                switch (result) {
                case .success():
                    Logger.info("notification action tracked successfully")
                    
                case .failure(let error):
                    Logger.error("failed to track notification action \(error.localizedDescription)")
                }
            }
        } catch {
            Logger.error("unexpected error occured : \(error.localizedDescription)")
        }
    }
    
    @objc
    public static func requestNotificationAuthorization(_ currentApplication: UIApplication) -> Void {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { value, error in
                if (error != nil) {
                }
            }
        )
        currentApplication.registerForRemoteNotifications()
    }
    
}

