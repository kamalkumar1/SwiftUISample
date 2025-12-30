//
//  AuthModels.swift
//  SampleUI
//
//  Created by kamalkumar on 29/12/25.
//

import Foundation

// MARK: - Login Request
struct LoginRequest: Codable {
    let email: String
    let password: String
}

// MARK: - Login Response
struct LoginResponse: Codable {
    let token: String
    let refreshToken: String?
    let user: UserModel
    let expiresIn: Int?
}

// MARK: - Signup Request
struct SignupRequest: Codable {
    let name: String
    let email: String
    let password: String
}

// MARK: - Signup Response
struct SignupResponse: Codable {
    let token: String
    let refreshToken: String?
    let user: UserModel
    let message: String?
}

// MARK: - Forgot Password Request
struct ForgotPasswordRequest: Codable {
    let email: String
}

// MARK: - Forgot Password Response
struct ForgotPasswordResponse: Codable {
    let message: String
    let resetToken: String?
}

// MARK: - Reset Password Request
struct ResetPasswordRequest: Codable {
    let token: String
    let newPassword: String
}

// MARK: - Reset Password Response
struct ResetPasswordResponse: Codable {
    let message: String
    let success: Bool
}

// MARK: - PIN Request
struct PINRequest: Codable {
    let pin: String
}

// MARK: - PIN Response
struct PINResponse: Codable {
    let success: Bool
    let message: String?
}

// MARK: - Update PIN Request
struct UpdatePINRequest: Codable {
    let oldPIN: String
    let newPIN: String
}

// MARK: - User Model
struct UserModel: Codable {
    let id: String
    let name: String
    let email: String
    let phoneNumber: String?
    let profileImage: String?
    let createdAt: String?
    let updatedAt: String?
}

// MARK: - API Response Wrapper
struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let message: String?
    let error: String?
}

// MARK: - Error Response
struct ErrorResponse: Codable {
    let error: String
    let message: String?
    let statusCode: Int?
}

