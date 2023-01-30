//
//  File.swift
//  
//
//  Created by bisenbrandt on 29/08/2022.
//

import Foundation

public class TelemetryService {
    
    public static let shared = TelemetryService()
    
    private let logger = Logger(label: "np6-messaging")
    
    public func log(_ config: Config, _ error: Error) {
        DispatchQueue.global(qos: .background).async {
            let event = Telemetry(error: error, application: config.application)
            TelemetryDriver
                .fromIdentity(identity: config.identity)
                .log(telemetry: event) { result in
                    switch(result) {
                    case .success(_):
                        self.logger.info("telemetry event logged successfully ")
                    case .failure(let error):
                        self.logger.error("telemetry event log failed \(error)")

                    }
                }
        }
    }
}
