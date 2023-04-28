//
//  File.swift
//  
//
//  Created by bisenbrandt on 20/03/2023.
//

import Foundation




public class SubscriptionApi {
    
    public enum ApiError: Error {
        case UrlFormattingError
        case NilOrBadHttpResponseCode
        case DataTaskFailure
    }
    
    public var basePath: String;
    
    public var session: URLSession;
    
    public static func create(_ identity: String)  -> SubscriptionApi {
        
        let agency = String(identity.prefix(4));
        let customer = String(identity.suffix(3));
        
        let basePath = ServiceUrls.Defaults.SubscriptionEndpoint + agency + "/" + customer
    
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        return SubscriptionApi(basePath, session);
    }
    
    
    public init(_ basePath: String, _ session: URLSession) {
        self.basePath = basePath;
        self.session = session;
    }
    
    @available(iOS 13.0.0, *)
    public func put(_ subscription: Subscription) async throws -> Subscription {
        return try await withCheckedThrowingContinuation({ continuation in
            put(subscription) { result in
                switch result {
                case .success(let successResult):
                    continuation.resume(returning: successResult)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
     
    public func put(_ subscription: Subscription, completion: @escaping (Result<Subscription, Error>) -> Void) {
        do {
            guard let url = URL(string: self.basePath + "/subscriptions") else {
                throw ApiError.UrlFormattingError
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body = try JSONEncoder().encode(subscription)
            
            request.httpBody = body

            self.session.dataTask(with: request, completionHandler: { data, response, error in
                
                guard error == nil else {
                    completion(.failure(error ?? ApiError.DataTaskFailure))
                    return;
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(.failure(ApiError.NilOrBadHttpResponseCode))
                    return;
                }
                                
                completion(.success(subscription))
            }).resume()

        } catch {
            completion(.failure(error))
        }
    }
}
