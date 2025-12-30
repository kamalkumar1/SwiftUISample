//
//  AuthServiceProtocol.swift
//  SampleUI
//
//  Created by kamalkumar on 29/12/25.
//

import Foundation
import Combine

/// Authentication service protocol
protocol AuthServiceProtocol {
    /// Login with email and password
    func login(email: String, password: String) async throws -> LoginResponse
    
    /// Sign up new user
    func signup(name: String, email: String, password: String) async throws -> SignupResponse
    
    /// Logout user
    func logout() async throws -> Bool
    
    /// Forgot password
    func forgotPassword(email: String) async throws -> ForgotPasswordResponse
    
    /// Reset password
    func resetPassword(token: String, newPassword: String) async throws -> ResetPasswordResponse
    
    /// Verify PIN
    func verifyPIN(pin: String) async throws -> PINResponse
    
    /// Set PIN
    func setPIN(pin: String) async throws -> PINResponse
    
    /// Update PIN
    func updatePIN(oldPIN: String, newPIN: String) async throws -> PINResponse
    
    // MARK: - Combine Versions
    
    /// Login with Combine
    func loginPublisher(email: String, password: String) -> AnyPublisher<LoginResponse, NetworkError>
}

