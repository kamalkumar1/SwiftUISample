//
//  UserService.swift
//  SampleUI
//
//  Created by kamalkumar on 29/12/25.
//

import Foundation

/// User service implementation
class UserService: UserServiceProtocol {
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func getUserProfile() async throws -> UserModel {
        let endpoint = APIEndpoint.getUserProfile
        return try await networkClient.request(endpoint, responseType: UserModel.self)
    }
    
    func updateUserProfile(profile: [String: Any]) async throws -> UserModel {
        let endpoint = APIEndpoint.updateUserProfile(profile: profile)
        return try await networkClient.request(endpoint, responseType: UserModel.self)
    }
    
    func changePassword(oldPassword: String, newPassword: String) async throws -> Bool {
        let endpoint = APIEndpoint.changePassword(oldPassword: oldPassword, newPassword: newPassword)
        let response: APIResponse<Bool> = try await networkClient.request(endpoint, responseType: APIResponse<Bool>.self)
        return response.success
    }
}

