//
//  File.swift
//
//
//  Created by bisenbrandt on 19/09/2022.
//

import Foundation


public class SubscriptionDriver {
    
    
    public var driver: Driver
    
    private init(identity: String, base: String) {
        self.driver = Driver.init(identity: identity, base: base)
    }
    
    public static func fromIdentity(identity: String) -> SubscriptionDriver {
        return SubscriptionDriver.init(identity: identity, base: ServiceUrls.Defaults.SubscriptionEndpoint)
    }
    
    public func create(subscription: Subscription, completion: @escaping (Result<Subscription, Error>) -> Void) {
        do {
            guard let url = URL(string: self.driver.baseUrl + "/subscriptions") else {
                completion(.failure(DriverError.InvalidBaseUrl(message: "Unable to format base driver url")))
                return;
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body = try JSONEncoder().encode(subscription)
            
            request.httpBody = body
            
            self.driver.session.dataTask(with: request, completionHandler: { data, response, error in
                
                guard error == nil else {
                    completion(.failure(error ?? DriverError.DataTaskFailure(message: "Datatask failed for unknow reason")))
                    return;
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completion(.success(subscription))
                        return
                    }
                    completion(
                        .failure(DriverError.HttpRequestFailed(
                            message: "Subscription update failed. HTTP status code \(httpResponse.statusCode) ",
                            code: httpResponse.statusCode)
                        )
                    )
                    return;
                }
            }).resume()
            
        } catch {
            completion(.failure(error))
            return;
        }
    }
    
    
    
    public func update(subscription: Subscription, completion: @escaping (Result<Subscription, Error>)->Void) {
        do {
            
            guard let url = URL(string: self.driver.baseUrl + "/subscriptions") else {
                completion(.failure(DriverError.InvalidBaseUrl(message: "Unable to format base driver url")))
                return;
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body = try JSONEncoder().encode(subscription)
            
            request.httpBody = body
            
            let task = self.driver.session.dataTask(with: request, completionHandler: { data, response, error in
                
                guard error == nil else {
                    completion(.failure(error ?? DriverError.DataTaskFailure(message: "Datatask failed for unknow reason")))
                    return;
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completion(.success(subscription))
                        return
                    }
                    completion(
                        .failure(DriverError.HttpRequestFailed(
                            message: "Subscription update failed. HTTP status code \(httpResponse.statusCode) ",
                            code: httpResponse.statusCode)
                        )
                    )
                    return;
                }
            })
            
            task.resume()
            
        } catch {
            completion(.failure(error))
            return;
        }
    }
}
