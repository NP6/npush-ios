//
//  File.swift
//  
//
//  Created by bisenbrandt on 24/06/2022.
//

import Foundation


public class Installation {
    
    public let identifierRepository: IdentifierRepository;
    
    public let tokenRepository: TokenRepository;
    
    public final let config: Config;
    
    public let subscriptionApi: SubscriptionApi;
        
    public enum InstallationError : Error {
        case InvalidToken
        case EmptyOrNullToken
        case InvalidIdentifier
    }
    
    public static func create(_ config: Config) -> Installation {
        
        let identifierRepository = IdentifierRepository.create();
        
        let tokenRepository = TokenRepository.create();
        
        let subscriptionApi = SubscriptionApi.create(config.identity)
        
        return Installation(
            config,
            identifierRepository,
            tokenRepository,
            subscriptionApi
        );
    }
        
    public init(
        _ config: Config,
        _ identifierRepository: IdentifierRepository,
        _ tokenRepository: TokenRepository,
        _ subscriptionApi: SubscriptionApi)
    {
        self.config = config;
        self.identifierRepository = identifierRepository;
        self.tokenRepository = tokenRepository;
        self.subscriptionApi = subscriptionApi;
    }
    
    public func getIdentifier() -> String? {
        return self.identifierRepository.exist()
        ? self.identifierRepository.get()
        : self.identifierRepository.add(element: UUID().uuidString)
        
    }
    
    public func subscribe(_ linked: Linked, completion: @escaping (Result<Subscription, Error>) -> Void) {
        do {
            
            if (self.tokenRepository.exist() == false) {
                throw InstallationError.EmptyOrNullToken
            }
            
            guard let token = self.tokenRepository.get() else {
                throw InstallationError.InvalidToken
            }
            
            guard let identifier = self.getIdentifier() else {
                throw InstallationError.InvalidIdentifier
            }
            
            guard let installationId = UUID(uuidString: identifier) else {
                throw InstallationError.InvalidIdentifier
            }
            
            let subscription = Subscription(
                id:  installationId,
                application: self.config.application,
                gateway: Gateway(token: token),
                linked: linked
            );
                        
            self.subscriptionApi.put(subscription) { result in
                switch(result) {
                    case .success(let subscription):
                        completion(.success(subscription))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
            
        } catch {
            completion(.failure(error))
        }
    }
}
