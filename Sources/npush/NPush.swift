import Foundation
import SwiftUI
import Foundation
import UIKit


@objc
@available(iOS 10.0, *)
public class NPush: NSObject {
    
    public var logger: Logger = ConsoleLogger()
    
    public weak var deeplinkDelegate: NPushDeeplinkDelegate?;
    
    @objc
    public static let instance: NPush = NPush();
    
    private var config: Config? = nil;
        
    private override init() {}
    
    @objc
    public func initialize(config: Config) -> Void {
        self.config = config;
        UIApplication.shared.registerForRemoteNotifications()
        NPNotificationCenter.createDefaultCategory(NPNotificationCenter.NOTIFICATION_DEFAULT_CATEGORY)
    }
    
    public func setContact(type: ContactType, value: String) {
        
        guard let config = self.config else {
            self.logger.error("config must be specified")
            return;
        }
        
        let contact = Linked.fromContactType(type, value)
        
        Installation
            .create(config)
            .subscribe(contact) { result in
            switch result {
                case .success(_):
                    self.logger.info("Subscription created successfully")
                    
                case .failure(let error):
                    self.logger.error("Subscription creation failed \(error)")
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
            
            let NPNotificationCenter  = NPNotificationCenter.initialize();
            
            let notification: Notification =  try NPNotificationCenter.parse(userInfo)
            
            NPNotificationCenter.handle(notification: notification, completion: { result in
                switch (result) {
                case .success():
                    self.logger.info("notification action tracked successfully")
                    
                case .failure(let error):
                    self.logger.error("failed to track notification action \(error.localizedDescription)")
                }
            })
        } catch {
            self.logger.error("failed to track notification action \(error.localizedDescription)")
        }
    }
    
    @objc
    public func didReceive(_ response: UNNotificationResponse) {
        do {
            
            let NPNotificationCenter  = NPNotificationCenter.initialize();

            let notification: Notification = try NPNotificationCenter.parse(response.notification.request.content.userInfo)
            
            NPNotificationCenter.handle(notification: notification, response: response) { result in
                switch (result) {
                case .success():
                    self.logger.info("notification action tracked successfully")
                    
                case .failure(let error):
                    self.logger.error("failed to track notification action \(error.localizedDescription)")
                }
            }
        } catch {
            self.logger.error("unexpected error occured : \(error.localizedDescription)")
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

