//
//  File.swift
//  
//
//  Created by bisenbrandt on 24/06/2022.
//

import Foundation


public class Installation {
    
    
    public enum InstallationResult<Found, NotFound> {
        case found(Found)
        case notfound(NotFound)
    }

    public static let shared = Installation.init(
        identifierRepository: IdentifierRepository.init(
            localStorage: LocalStorage.init(
                adapter: UserDefaultStorage.init(namespace: "identifier")
            )
        )
    )
    
    private var identifierRepository: IdentifierRepository
    
    public init(identifierRepository: IdentifierRepository) {
        self.identifierRepository = identifierRepository
    }
    
    
    public enum TokenError : Error {
        case InvalidTokenDeserialization
    }
    
    
    public func CheckIfTokenExist(completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let token = try TokenService.shared.get()
            completion(.success(token))
        } catch {
            completion(.failure(TokenError.InvalidTokenDeserialization))
        }
        
    }
    
    public func Install(
        _ config: Config,
        _ linked: Linked,
        _ identity: String,
        completion: @escaping (Result<Subscription, Error>) -> Void) {
            
            let newIdentifier = self.identifierRepository.Add(element: UUID())
            
            self.CheckIfTokenExist() { result in
                switch result {
                    case .success(let token):
                        SubscriptionService.shared.Create(newIdentifier, config.application, token , linked, identity) { result in
                            switch result {
                            case .success(let id):
                                completion(.success(id))
                                
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
            
            
        }
    
    public func Update(
        _ identifier: UUID,
        _ config: Config,
        _ linked: Linked,
        _ identity: String,
        completion: @escaping (Result<Subscription, Error>) -> Void) {
            self.CheckIfTokenExist() { result in
                switch result {
                case .success(let token):
                    SubscriptionService.shared.Update(identifier, config.application, token, linked, identity) { result in
                        switch result {
                        case .success(let subscription):
                            completion(.success(subscription))
                            
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
        }
    
    
    public func CheckInstallation(completion: @escaping (Result<UUID, Error>)->Void) {
        IdentifierService.shared.Get { result in
            switch result {
            case .success(let id):
                completion(.success(id))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
