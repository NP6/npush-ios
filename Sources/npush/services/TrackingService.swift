//
//  File.swift
//  
//
//  Created by bisenbrandt on 17/08/2022.
//

import Foundation
import SwiftUI
import Foundation
import UIKit

public class TrackingService {
    
    public enum TrackingError: Error {
        case InvalidEndpoint
        case InvalidTrackingModel(message: String)
        case UnknowNotificationActionIdentifier
    }
    
    public static let shared = TrackingService()
    
    
    public func parse(_ userInfo : [AnyHashable : Any]) throws -> Tracking {
        guard let tracking = userInfo["tracking"] as? [AnyHashable : Any] else {
            throw TrackingError.InvalidTrackingModel(message: "tracking property missing");
        }
        
        guard let dismiss = tracking["dismiss"] as? String else {
            throw TrackingError.InvalidTrackingModel(message: "dismiss property missing");
        }
        
        guard let radical = tracking["radical"] as? String else {
            throw TrackingError.InvalidTrackingModel(message: "radical property missing");
        }
        
        guard let impression = tracking["impression"] as? String else {
            throw TrackingError.InvalidTrackingModel(message: "impression property missing");
        }
        
        guard let redirection = tracking["redirection"] as? String else {
            throw TrackingError.InvalidTrackingModel(message: "redirection property missing");
        }
        
        return Tracking(
            dismiss: dismiss,
            impression: impression,
            redirection: redirection,
            radical: radical
        )
    }
    
    @available(iOS 10.0, *)
    public func handle(_ userInfo: [AnyHashable : Any], withCompletionHandler completionHandler: @escaping (Result<Int, Error>) -> Void) -> Void {
        do {
            let tracking  = try self.parse(userInfo)
            
            TrackingDriver
                .fromRadical(radical: tracking.radical)
                .impression(impression: tracking.impression) { result in
                    switch result {
                    case .success(let statusCode):
                        completionHandler(.success(statusCode))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    @available(iOS 10.0, *)
    public func handleResponse(_ response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping (Result<Int, Error>) -> Void) -> Void {
        do {
            let tracking = try self.parse(response.notification.request.content.userInfo)
            
            switch (response.actionIdentifier) {
            case UNNotificationDefaultActionIdentifier:
                TrackingDriver
                    .fromRadical(radical: tracking.radical)
                    .redirection(redirection: tracking.redirection) { result in
                        switch result {
                        case .success(let statusCode):
                            completionHandler(.success(statusCode))
                        case .failure(let error):
                            completionHandler(.failure(error))
                        }
                    }
                
            case UNNotificationDismissActionIdentifier:
                TrackingDriver
                    .fromRadical(radical: tracking.radical)
                    .dismiss(dismiss: tracking.dismiss) { result in
                        switch result {
                        case .success(let statusCode):
                            completionHandler(.success(statusCode))
                        case .failure(let error):
                            completionHandler(.failure(error))
                        }
                    }
            default:
                completionHandler(.failure(TrackingError.UnknowNotificationActionIdentifier))
            }
        } catch {
            completionHandler(.failure(error))
        }
        
    }
    
}
