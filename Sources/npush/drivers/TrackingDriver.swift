//
//  File.swift
//  
//
//  Created by bisenbrandt on 21/09/2022.
//

import Foundation
//
//  File.swift
//
//
//  Created by bisenbrandt on 19/09/2022.
//

import Foundation


public class TrackingDriver {
    
    public var driver: Driver
    
    private init(base: String) {
        self.driver = Driver.init(base: base)
    }
    
    public static func fromRadical(radical: String) -> TrackingDriver {
        return TrackingDriver(base: radical)
    }
    
    public func redirection(redirection: String, completion: @escaping (Result<Int, Error>) -> Void) {
        guard let url = URL(string: self.driver.baseUrl + redirection) else {
            completion(.failure(DriverError.InvalidBaseUrl(message: "Unable to format base driver url")))
            return;
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        self.driver.session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(.failure(error ?? DriverError.DataTaskFailure(message: "Datatask failed for unknow reason")))
                return;
            }
                 
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 204 || httpResponse.statusCode == 200 {
                    completion(.success(httpResponse.statusCode))
                    return
                }
                completion(
                    .failure(DriverError.HttpRequestFailed(
                        message: "Tracking redirection event. HTTP status code \(httpResponse.statusCode) ",
                        code: httpResponse.statusCode)
                    )
                )
                return;
            }
        }).resume()
    }
    
    public func dismiss(dismiss: String, completion: @escaping (Result<Int, Error>) -> Void) {
        guard let url = URL(string: self.driver.baseUrl + dismiss) else {
            completion(.failure(DriverError.InvalidBaseUrl(message: "Unable to format base driver url")))
            return;
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        self.driver.session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(.failure(error ?? DriverError.DataTaskFailure(message: "Datatask failed for unknow reason")))
                return;
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 204 || httpResponse.statusCode == 200 {
                    completion(.success(httpResponse.statusCode))
                    return
                }
                completion(
                    .failure(DriverError.HttpRequestFailed(
                        message: "Tracking dismiss event. HTTP status code \(httpResponse.statusCode) ",
                        code: httpResponse.statusCode)
                    )
                )
                return;
            }
        }).resume()
    }
    
    public func impression(impression: String, completion: @escaping (Result<Int, Error>) -> Void) {
        guard let url = URL(string: self.driver.baseUrl + impression) else {
            completion(.failure(DriverError.InvalidBaseUrl(message: "Unable to format base driver url")))
            return;
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        self.driver.session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(.failure(error ?? DriverError.DataTaskFailure(message: "Datatask failed for unknow reason")))
                return;
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 204 || httpResponse.statusCode == 200 {
                    completion(.success(httpResponse.statusCode))
                    return
                }
                completion(
                    .failure(DriverError.HttpRequestFailed(
                        message: "Tracking impression event failed. HTTP status code \(httpResponse.statusCode) ",
                        code: httpResponse.statusCode)
                    )
                )
                return;
            }
        }).resume()
    }
    
}
