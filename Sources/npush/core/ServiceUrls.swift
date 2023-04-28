//
//  ServiceUrls.swift
//  push
//
//  Created by bisenbrandt on 02/06/2022.
//

import Foundation

enum ServiceUrls {
    enum Defaults {
        
#if DEBUG
        static let SubscriptionEndpoint = "http://cm-push.kube.dev.np6.com/api/v1.0/"
        static let TelemetryEnpoint = "http://telemetry.kube.dev.np6.com/api/v1.0/"
#else
        static let SubscriptionEndpoint = "https://subscriptions.np6.com/api/v1.0/"
        static let TelemetryEnpoint = "https://telemetry.np6.com/api/v1.0/"
#endif
    }
}
