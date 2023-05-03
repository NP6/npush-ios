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
                case .success(let subscription):
                    self.logger.info("Subscription created successfully")
                    
                case .failure(let error):
                    self.logger.error("Subscription creation failed \(error.localizedDescription)")
                }
            }
    }
    
    @objc
    public func handleRegistrationToken(deviceToken: Data) {
        let data = deviceToken.map { String(format: "%02.2hhx", $0) }
        
        let token = data.joined()

        TokenRepository.create().add(element: token)
    }
    
    @objc
    public func didReceive(request: UNNotificationRequest, contentHandler: ((UNNotificationContent) -> Void)?) {
        do {
            let content = (request.content.mutableCopy() as? UNMutableNotificationContent)
            
            guard let contentHandler = contentHandler else {
                self.logger.warning("nil contentHandler argument")
                return;
            }
            guard let attemptContent = content else { self.logger.error("failed to get valid content"); return; }
            
            let userInfo = attemptContent.userInfo
            
            let NPNotificationCenter = NPNotificationCenter.initialize();
            
            let notification: Notification = try NPNotificationCenter.parse(userInfo)
            
            NPNotificationCenter.handle(notification: notification, completion: { result in
                switch (result) {
                case .success():
                    self.logger.info("notification action tracked successfully")
                    contentHandler(attemptContent)
                    
                case .failure(let error):
                    self.logger.error("failed to track notification action \(error.localizedDescription)")
                    contentHandler(attemptContent)
                }
            })
        } catch {
            self.logger.error("unexpected error occured : \(error.localizedDescription)")
            guard let contentHandler = contentHandler else {
                return;
            }
            contentHandler(request.content)
        }
    }
    
    
    @objc
    public func didReceive(response: UNNotificationResponse) {
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
    public func didReceiveRemoteNotification(_ application: UIApplication, userInfo: [AnyHashable : Any]) {
        
        do {
            let NPNotificationCenter  = NPNotificationCenter.initialize()
            
            let notification: Notification = try NPNotificationCenter.parse(userInfo)
            
            NPNotificationCenter.isNotificationActive() { areNotificationActive in
                if areNotificationActive {
                    return;
                }
                NPNotificationCenter.handle(notification: notification, completion: { result in
                    switch (result) {
                    case .success():
                        self.logger.info("notification action tracked successfully")
                        
                    case .failure(let error):
                        self.logger.error("failed to track notification action \(error.localizedDescription)")
                    }
                })
            }
        } catch {
            self.logger.error("unexpected error occured : \(error.localizedDescription)")
        }
    }
}

