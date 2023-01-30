//
//  File.swift
//  
//
//  Created by bisenbrandt on 23/06/2022.
//

import Foundation

enum WebServiceError: Error {
    case SubscriptionSerializationError
}

public class SubscriptionService {
    
    public static let shared = SubscriptionService.init()
    
    public func Create(
        _ identifier: UUID,
        _ application: UUID,
        _ token: String,
        _ linked: Linked,
        _ identity: String, completion: @escaping (Result<Subscription, Error>)->Void) {
            
            let subscription = Subscription(
                id: identifier,
                application: application,
                gateway: Gateway.init(token: token),
                linked: linked
            )
            
            SubscriptionDriver
                .fromIdentity(identity: identity)
                .create(subscription: subscription) { result in
                    switch(result) {
                    case .success(let subscription):
                        completion(.success(subscription))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
    
    public func Update(
        _ identifier: UUID,
        _ application: UUID,
        _ token: String,
        _ linked: Linked,
        _ identity: String, completion: @escaping (Result<Subscription, Error>) -> Void) {
            
            let subscription = Subscription(
                id: identifier,
                application: application,
                gateway: Gateway.init(token: token),
                linked: linked
            )
            
            SubscriptionDriver
                .fromIdentity(identity: identity)
                .update(subscription: subscription) { result in
                    switch(result) {
                    case .success(let subscription):
                        completion(.success(subscription))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
}
