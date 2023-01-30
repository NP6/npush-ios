//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by bisenbrandt on 26/07/2022.
//

import UserNotifications


public class TokenService {
    
    public static let shared = TokenService.init(
        tokenRepository: TokenRepository.init(
            localStorage: LocalStorage.init(
                adapter: UserDefaultStorage.init(namespace: "token")
            )
        )
    )
    
    public var tokenRepository: TokenRepository;
    
    init(tokenRepository: TokenRepository) {
        self.tokenRepository = tokenRepository;
    }
    
    public func save(token: String) -> String {
        return self.tokenRepository.Add(element: token)
    }
    
    public func get() throws -> String  {
        return try self.tokenRepository.Get();
    }
}
