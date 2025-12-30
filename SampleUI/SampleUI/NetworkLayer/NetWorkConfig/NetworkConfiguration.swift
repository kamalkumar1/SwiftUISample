//
//  NetworkConfiguration.swift
//  SampleUI
//
//  Created by kamalkumar on 29/12/25.
//

import Foundation

/// Network configuration manager
class NetworkConfiguration {
    static let shared = NetworkConfiguration()
    
    /// Base URL for API requests
    var baseURL: String {
        #if DEBUG
        return "https://api-dev.example.com/v1" // Development
        #else
        return "https://api.example.com/v1" // Production
        #endif
    }
    
    /// API Key (if needed)
    var apiKey: String? {
        return nil // Set your API key here
    }
    
    /// Default headers
    var defaultHeaders: [String: String] {
        var headers: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        if let apiKey = apiKey {
            headers["X-API-Key"] = apiKey
        }
        
        return headers
    }
    
    /// Request timeout
    var timeout: TimeInterval {
        return 30.0
    }
    
    /// Enable/disable logging
    var enableLogging: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    private init() {}
}

