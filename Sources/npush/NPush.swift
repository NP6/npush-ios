import Foundation
import SwiftUI
import Foundation
import UIKit

@available(iOS 10.0, *)
@objc
public class NPush: NSObject {
    
    
    public weak var deeplinkDelegate: NPushDeeplinkDelegate?;
    
    @objc
    public static let instance: NPush = NPush();
    
    private var config: Config? = nil;
    
    private let logger = Logger(label: "np6-messaging")
    
    private override init() {}
    
    /// Initialize NPush SDK with a specified configuration.
    /// A valid configuration is required
    /// - Parameter config: The SDK configuration representation
    @objc
    public func InitWithConfig(config: Config) -> Void {
        let defaultCategory = NotificationService.createDefaultCategory("Default_Notification_Category")
        UNUserNotificationCenter.current().setNotificationCategories([defaultCategory])
        self.config = config;
        SetContact(type: .HashRepresentation, value: "")
        
    }
    
    /// Link the current device subscription to specifiied NP6 target in input.
    /// - Parameter targetIdentifier: The target unicity hash.
    @objc
    public func SetContact(type: ContactType, value: String) -> Void {
        DispatchQueue.global(qos: .background).async {
            
            guard let config = self.config else {
                self.logger.error("Unable to find configuration. call InitWithConfig() before.")
                return;
            }
            let linked = self.CreateLinked(type, value)
            
            self.CheckIfInstalled() { installation in
                switch installation {
                case .found(let id):
                    Installation.shared.Update(id, config, linked, config.identity) { result in
                        switch result {
                        case .success(let subscription):
                            self.logger.info("Device subscription updated successfully \(subscription.id)  \(subscription.gateway.token)  ")
                            
                        case .failure(let error):
                            self.logger.error("Failed to update device subscription. \(error) " )
                            TelemetryService.shared.log(config, error)
                        }
                    }
                case .notfound(_):
                    Installation.shared.Install(config, linked, config.identity) { result in
                        switch result {
                        case .success(let subscription):
                            self.logger.info("Device subscription created successfully \(subscription.id)  \(subscription.gateway.token)  ")
                            
                        case .failure(let error):
                            self.logger.error("Failed to create device subscription \(error) " )
                            TelemetryService.shared.log(config, error)
                        }
                    }
                }
            }
        }
    }
    /// Used to associate a device token to the current push subscription.
    /// - Parameter deviceToken: The device token in Data type format.
    ///
    @objc
    public func SetToken(deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        DispatchQueue.global(qos: .background).async {
            TokenService.shared.save(token: token)
        }
    }
    
    
    
    @available(iOS 10.0, *)
    @objc
    public func willPresent(_ userInfo: [AnyHashable : Any]) -> Void {
        TrackingService.shared.handle(userInfo) { result in
            switch result {
            case .success :
                self.logger.info("Notification action tracked successfully.")
            case .failure(let error):
                self.logger.error("Notification action tracking failed. \(error)")
            }
        }
        
    }
    
    @available(iOS 10.0, *)
    @objc
    public func didReceive(_ response: UNNotificationResponse) {
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            NotificationService.launchDeeplink(response.notification.request.content.userInfo) { result in
                switch result {
                case .success:
                    self.logger.info("Deeplink launched successfully.")
                case .failed(let error):
                    self.logger.error("Deeplink failed to launch. \(error)")
                }
            }
        }
        
        TrackingService.shared.handleResponse(response) { result in
            switch result {
            case .success:
                self.logger.info("Notification action tracked successfully.")
            case .failure(let error):
                self.logger.error("Notification action tracking failed. \(error)")
            }
        }
    }
    
    @objc
    public static func requestNotificationAuthorization(_ currentApplication: UIApplication) -> Void {
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            currentApplication.registerUserNotificationSettings(settings)
        }
        currentApplication.registerForRemoteNotifications()
    }
    
}


@available(iOS 10.0, *)
extension NPush {
    private func CheckIfInstalled(completion: @escaping (Installation.InstallationResult<UUID, Error>)->Void) {
        Installation.shared.CheckInstallation() { result in
            switch result {
            case .success(let id):
                completion(.found(id))
            case .failure(let error):
                completion(.notfound(error))
            }
        }
    }
    
    private func CreateLinked(_ type: ContactType, _ value: String) -> Linked {
        switch(type) {
            case .UnicityRepresentation:
                return Linked(type: "unicity", identifier: value)
            case .IdRepresentation:
                return Linked(type: "id", identifier: value)
            case .HashRepresentation:
                return Linked(type: "hash", identifier: value)
        }
    }
}
