//
//  UserServiceProtocol.swift
//  SampleUI
//
//  Created by kamalkumar on 29/12/25.
//

import Foundation

/// User service protocol
protocol UserServiceProtocol {
    /// Get user profile
    func getUserProfile() async throws -> UserModel
    
    /// Update user profile
    func updateUserProfile(profile: [String: Any]) async throws -> UserModel
    
    /// Change password
    func changePassword(oldPassword: String, newPassword: String) async throws -> Bool
}

