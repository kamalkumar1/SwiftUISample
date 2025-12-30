//
//  NetworkClientProtocol.swift
//  SampleUI
//
//  Created by kamalkumar on 29/12/25.
//

import Foundation
import Combine

/// Protocol for network client
protocol NetworkClientProtocol {
    /// Perform a network request and decode the response
    func request<T: Decodable>(
        _ request: NetworkRequest,
        responseType: T.Type
    ) async throws -> T
    
    /// Perform a network request and return raw data
    func requestData(_ request: NetworkRequest) async throws -> Data
    
    /// Perform a network request with Combine
    func requestPublisher<T: Decodable>(
        _ request: NetworkRequest,
        responseType: T.Type
    ) -> AnyPublisher<T, NetworkError>
    
    /// Set authorization token
    func setAuthorizationToken(_ token: String?)
    
    /// Clear authorization token
    func clearAuthorizationToken()
}

