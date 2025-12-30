//
//  NetworkClient.swift
//  SampleUI
//
//  Created by kamalkumar on 29/12/25.
//

import Foundation
import Combine

/// Network client implementation
class NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private var authorizationToken: String?
    private let configuration: NetworkConfiguration
    
    init(session: URLSession = .shared,configuration: NetworkConfiguration = .shared) {
        self.session = session
        self.configuration = configuration
    }
    
    // MARK: - Async/Await Implementation
    
    func request<T: Decodable>(
        _ request: NetworkRequest,
        responseType: T.Type
    ) async throws -> T {
        let urlRequest = try buildRequest(from: request)
        
        if configuration.enableLogging {
            logRequest(urlRequest)
        }
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            if configuration.enableLogging {
                logResponse(data: data, response: response)
            }
            
            try validateResponse(response)
            let decoded = try decodeResponse(data: data, type: responseType)
            return decoded
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
    func requestData(_ request: NetworkRequest) async throws -> Data {
        let urlRequest = try buildRequest(from: request)
        
        if configuration.enableLogging {
            logRequest(urlRequest)
        }
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            if configuration.enableLogging {
                logResponse(data: data, response: response)
            }
            
            try validateResponse(response)
            return data
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(error)
        }
    }
    
    // MARK: - Combine Implementation
    
    func requestPublisher<T: Decodable>(
        _ request: NetworkRequest,
        responseType: T.Type
    ) -> AnyPublisher<T, NetworkError> {
        do {
            let urlRequest = try buildRequest(from: request)
            
            if configuration.enableLogging {
                logRequest(urlRequest)
            }
            
            return session.dataTaskPublisher(for: urlRequest)
                .tryMap { [weak self] data, response -> Data in
                    guard let self = self else {
                        throw NetworkError.unknown(NSError(domain: "NetworkClient", code: -1))
                    }
                    
                    if self.configuration.enableLogging {
                        self.logResponse(data: data, response: response)
                    }
                    
                    try self.validateResponse(response)
                    return data
                }
                .decode(type: responseType, decoder: JSONDecoder())
                .mapError { error -> NetworkError in
                    if let networkError = error as? NetworkError {
                        return networkError
                    } else if error is DecodingError {
                        return NetworkError.decodingError(error)
                    } else {
                        return NetworkError.unknown(error)
                    }
                }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: NetworkError.unknown(error))
                .eraseToAnyPublisher()
        }
    }
    
    // MARK: - Authorization
    
    func setAuthorizationToken(_ token: String?) {
        authorizationToken = token
    }
    
    func clearAuthorizationToken() {
        authorizationToken = nil
    }
    
    // MARK: - Private Helpers
    
    private func buildRequest(from networkRequest: NetworkRequest) throws -> URLRequest {
        var request = try networkRequest.buildRequest()
        
        // Add default headers
        for (key, value) in configuration.defaultHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add authorization token if available
        if let token = authorizationToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return // Success
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.serverError(message: "Server error: \(httpResponse.statusCode)")
        default:
            throw NetworkError.httpError(
                statusCode: httpResponse.statusCode,
                message: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
            )
        }
    }
    
    private func decodeResponse<T: Decodable>(
        data: Data,
        type: T.Type
    ) throws -> T {
        guard !data.isEmpty else {
            throw NetworkError.noData
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase // Handles snake_case to camelCase
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(type, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - Logging
    
    private func logRequest(_ request: URLRequest) {
        print("🌐 [REQUEST] \(request.httpMethod ?? "?") \(request.url?.absoluteString ?? "?")")
        if let headers = request.allHTTPHeaderFields {
            print("📋 Headers: \(headers)")
        }
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("📦 Body: \(bodyString)")
        }
    }
    
    private func logResponse(data: Data, response: URLResponse) {
        if let httpResponse = response as? HTTPURLResponse {
            print("📥 [RESPONSE] Status: \(httpResponse.statusCode)")
        }
        if let responseString = String(data: data, encoding: .utf8) {
            print("📦 Response: \(responseString.prefix(500))")
        }
    }
}

