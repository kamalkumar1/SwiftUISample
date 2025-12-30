//
//  APIEndpoints.swift
//  SampleUI
//
//  Created by kamalkumar on 29/12/25.
//

import Foundation

/// API Endpoints for the application
enum APIEndpoint {
    // MARK: - Authentication
    case login(email: String, password: String)
    case signup(name: String, email: String, password: String)
    case logout
    case forgotPassword(email: String)
    case resetPassword(token: String, newPassword: String)
    case refreshToken(token: String)
    
    // MARK: - User
    case getUserProfile
    case updateUserProfile(profile: [String: Any])
    case changePassword(oldPassword: String, newPassword: String)
    
    // MARK: - PIN
    case verifyPIN(pin: String)
    case setPIN(pin: String)
    case updatePIN(oldPIN: String, newPIN: String)
}

extension APIEndpoint: NetworkRequest {
    var path: String {
        switch self {
        // Authentication
        case .login:
            return "/auth/login"
        case .signup:
            return "/auth/signup"
        case .logout:
            return "/auth/logout"
        case .forgotPassword:
            return "/auth/forgot-password"
        case .resetPassword:
            return "/auth/reset-password"
        case .refreshToken:
            return "/auth/refresh-token"
        
        // User
        case .getUserProfile:
            return "/user/profile"
        case .updateUserProfile:
            return "/user/profile"
        case .changePassword:
            return "/user/change-password"
        
        // PIN
        case .verifyPIN:
            return "/auth/verify-pin"
        case .setPIN:
            return "/auth/set-pin"
        case .updatePIN:
            return "/auth/update-pin"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .signup, .logout, .forgotPassword, .resetPassword, .refreshToken:
            return .post
        case .getUserProfile:
            return .get
        case .updateUserProfile, .changePassword, .verifyPIN, .setPIN, .updatePIN:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .login(let email, let password):
            return ["email": email, "password": password]
        case .signup(let name, let email, let password):
            return ["name": name, "email": email, "password": password]
        case .forgotPassword(let email):
            return ["email": email]
        case .resetPassword(let token, let newPassword):
            return ["token": token, "newPassword": newPassword]
        case .refreshToken(let token):
            return ["refreshToken": token]
        case .updateUserProfile(let profile):
            return profile
        case .changePassword(let oldPassword, let newPassword):
            return ["oldPassword": oldPassword, "newPassword": newPassword]
        case .verifyPIN(let pin):
            return ["pin": pin]
        case .setPIN(let pin):
            return ["pin": pin]
        case .updatePIN(let oldPIN, let newPIN):
            return ["oldPIN": oldPIN, "newPIN": newPIN]
        default:
            return nil
        }
    }
    
    var headers: [String: String]? {
        // Add any endpoint-specific headers here
        return nil
    }
}

