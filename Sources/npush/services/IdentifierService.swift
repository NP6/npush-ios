//
//  File.swift
//  
//
//  Created by bisenbrandt on 27/06/2022.
//

import Foundation


public class IdentifierService {
    
    
    public static let shared = IdentifierService(
        repository: IdentifierRepository.init(
            localStorage: LocalStorage.init(
                adapter: UserDefaultStorage.init(namespace: "identifier")
            )
        )
    )
    
    public var repository: IdentifierRepository
    
    
    public init(repository: IdentifierRepository) {
        self.repository = repository
    }
    
    public func Get(completion: @escaping (Result<UUID, Error>) -> Void) {
        do {
            let identifier = try self.repository.Get();
            completion(.success(identifier))
        } catch {
            completion(.failure(error))
        }
        
    }
    
    public func Exist() -> Bool {
        return self.repository.Exist()
    }
}
