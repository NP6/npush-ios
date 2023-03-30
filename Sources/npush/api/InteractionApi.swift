//
//  File.swift
//
//
//  Created by bisenbrandt on 20/03/2023.
//

import Foundation




public class InteractionApi {
    
    public enum ApiError: Error {
        case UrlFormattingError
        case NilOrEmptyHttpResponse
        case DataTaskFailure
        case NilOrBadHttpResponseCode
    }
        
    public var session: URLSession;
    
    public static func create()  -> InteractionApi {
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        return InteractionApi(session);
    }
    
    
    public init (_ session: URLSession) {
        self.session = session;
    }
         
    public func get(_ radical: String, _ ressource: String, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            guard let url = URL(string: radical + ressource) else {
                throw ApiError.UrlFormattingError
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
                        
            self.session.dataTask(with: request, completionHandler: {  data, response, error in
                
                guard error == nil else {
                    completion(.failure(error ?? ApiError.DataTaskFailure))
                    return;
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 || httpResponse.statusCode == 200  else {
                    completion(.failure(ApiError.NilOrBadHttpResponseCode))
                    return;
                }
                                
                completion(.success(()))
            }).resume()

        } catch {
            completion(.failure(error))
        }
    }
}
