//
//  File.swift
//  
//
//  Created by bisenbrandt on 21/09/2022.
//

import Foundation

public class TelemetryDriver {
    
    
    public var driver: Driver
    
    private init(identity: String, base: String) {
        self.driver = Driver.init(identity: identity, base: base)
    }
    
    public static func fromIdentity(identity: String) -> TelemetryDriver {
        return TelemetryDriver.init(identity: identity, base: ServiceUrls.Defaults.TelemetryEnpoint)
    }
    
    public func log(telemetry: Telemetry, completion: @escaping (Result<Telemetry, Error>) -> Void) {
        do {
            guard let url = URL(string: self.driver.baseUrl + "/telemetry") else {
                completion(.failure(DriverError.InvalidBaseUrl(message: "Unable to format base driver url")))
                return;
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body = try JSONEncoder().encode(telemetry)
            
            request.httpBody = body
            
            self.driver.session.dataTask(with: request, completionHandler: { data, response, error in
                
                guard error == nil else {
                    completion(.failure(error ?? DriverError.DataTaskFailure(message: "Datatask failed for unknow reason")))
                    return;
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completion(.success(telemetry))
                        return
                    }
                    completion(
                        .failure(DriverError.HttpRequestFailed(
                            message: "Telemetry log failed. HTTP status code \(httpResponse.statusCode) ",
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
}
