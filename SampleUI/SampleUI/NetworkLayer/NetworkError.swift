//
//  NetworkError.swift
//  SampleUI
//
//  Created by kamalkumar on 29/12/25.
//

import Foundation

/// Network layer error types
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int, message: String?)
    case decodingError(Error)
    case encodingError(Error)
    case noData
    case networkUnavailable
    case timeout
    case unauthorized
    case forbidden
    case notFound
    case serverError(message: String?)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode, let message):
            return message ?? "HTTP Error: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .noData:
            return "No data received from server"
        case .networkUnavailable:
            return "Network connection unavailable"
        case .timeout:
            return "Request timeout"
        case .unauthorized:
            return "Unauthorized - Please login again"
        case .forbidden:
            return "Forbidden - Access denied"
        case .notFound:
            return "Resource not found"
        case .serverError(let message):
            return message ?? "Server error occurred"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
    
    var statusCode: Int? {
        switch self {
        case .httpError(let code, _):
            return code
        case .unauthorized:
            return 401
        case .forbidden:
            return 403
        case .notFound:
            return 404
        default:
            return nil
        }
    }
}

