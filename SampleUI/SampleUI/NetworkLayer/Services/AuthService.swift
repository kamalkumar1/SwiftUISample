//
//  AuthService.swift
//  SampleUI
//
//  Created by kamalkumar on 29/12/25.
//

import Foundation
import Combine

/// Authentication service implementation
class AuthService: AuthServiceProtocol {
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    // MARK: - Async/Await Implementation
    
    func login(email: String, password: String) async throws -> LoginResponse {
        let endpoint = APIEndpoint.login(email: email, password: password)
        let response: LoginResponse = try await networkClient.request(endpoint, responseType: LoginResponse.self)
        
        // Store token after successful login
        if let token = response.token as String? {
            networkClient.setAuthorizationToken(token)
            // Store token in UserDefaults or Keychain
            UserDefaults.standard.set(token, forKey: "authToken")
        }
        
        return response
    }
    
    func signup(name: String, email: String, password: String) async throws -> SignupResponse {
        let endpoint = APIEndpoint.signup(name: name, email: email, password: password)
        let response: SignupResponse = try await networkClient.request(endpoint, responseType: SignupResponse.self)
        
        // Store token after successful signup
        if let token = response.token as String? {
            networkClient.setAuthorizationToken(token)
            UserDefaults.standard.set(token, forKey: "authToken")
        }
        
        return response
    }
    
    func logout() async throws -> Bool {
        let endpoint = APIEndpoint.logout
        let response: APIResponse<Bool> = try await networkClient.request(endpoint, responseType: APIResponse<Bool>.self)
        
        // Clear token on logout
        networkClient.clearAuthorizationToken()
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        
        return response.success
    }
    
    func forgotPassword(email: String) async throws -> ForgotPasswordResponse {
        let endpoint = APIEndpoint.forgotPassword(email: email)
        return try await networkClient.request(endpoint, responseType: ForgotPasswordResponse.self)
    }
    
    func resetPassword(token: String, newPassword: String) async throws -> ResetPasswordResponse {
        let endpoint = APIEndpoint.resetPassword(token: token, newPassword: newPassword)
        return try await networkClient.request(endpoint, responseType: ResetPasswordResponse.self)
    }
    
    func verifyPIN(pin: String) async throws -> PINResponse {
        let endpoint = APIEndpoint.verifyPIN(pin: pin)
        return try await networkClient.request(endpoint, responseType: PINResponse.self)
    }
    
    func setPIN(pin: String) async throws -> PINResponse {
        let endpoint = APIEndpoint.setPIN(pin: pin)
        return try await networkClient.request(endpoint, responseType: PINResponse.self)
    }
    
    func updatePIN(oldPIN: String, newPIN: String) async throws -> PINResponse {
        let endpoint = APIEndpoint.updatePIN(oldPIN: oldPIN, newPIN: newPIN)
        return try await networkClient.request(endpoint, responseType: PINResponse.self)
    }
    
    // MARK: - Combine Implementation
    
    func loginPublisher(email: String, password: String) -> AnyPublisher<LoginResponse, NetworkError> {
        let endpoint = APIEndpoint.login(email: email, password: password)
        return networkClient.requestPublisher(endpoint, responseType: LoginResponse.self)
            .handleEvents(receiveOutput: { [weak self] response in
                // Store token after successful login
                if let token = response.token as String? {
                    self?.networkClient.setAuthorizationToken(token)
                    UserDefaults.standard.set(token, forKey: "authToken")
                }
            })
            .eraseToAnyPublisher()
    }
}

