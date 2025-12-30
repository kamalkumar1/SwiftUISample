//
//  NetworkRequest.swift
//  SampleUI
//
//  Created by kamalkumar on 29/12/25.
//

import Foundation

/// HTTP Methods
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

/// Request configuration protocol
protocol NetworkRequest {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var body: Data? { get }
    var timeout: TimeInterval { get }
}

extension NetworkRequest {
    var baseURL: String {
        return NetworkConfiguration.shared.baseURL
    }
    
    var timeout: TimeInterval {
        return 30.0
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var body: Data? {
        return nil
    }
    
    /// Builds the full URL with query parameters
    func buildURL() throws -> URL {
        var urlString = baseURL + path
        
        // Add query parameters for GET requests
        if method == .get, let parameters = parameters, !parameters.isEmpty {
            var components = URLComponents(string: urlString)
            components?.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            urlString = components?.url?.absoluteString ?? urlString
        }
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        return url
    }
    
    /// Builds the URLRequest
    func buildRequest() throws -> URLRequest {
        let url = try buildURL()
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeout
        
        // Set default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Set custom headers
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Set body for POST/PUT/PATCH requests
        if method != .get, let body = body {
            request.httpBody = body
        } else if method != .get, let parameters = parameters {
            // Encode parameters as JSON
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        return request
    }
}

