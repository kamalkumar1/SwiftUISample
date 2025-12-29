//
//  AppAssembly.swift
//  SampleUI
//
//  Created by kamalkumar on 29/12/25.
//

import Foundation
import Swinject

/// Example Assembly class demonstrating how to organize dependency registrations
/// This follows Swinject's recommended Assembly pattern
class AppAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - ViewModels
        // Example: Register ViewModels
        // container.register(LoginViewModel.self) { resolver in
        //     let navigationManager = resolver.resolve(NavigationManager.self)!
        //     return LoginViewModel(navigationManager: navigationManager)
        // }.inObjectScope(.transient)
        
        // MARK: - Services
        // Example: Register Services
        // container.register(AuthServiceProtocol.self) { _ in
        //     AuthService()
        // }.inObjectScope(.container) // Singleton
        
        // MARK: - Managers
        // Example: Register Managers
        // container.register(NavigationManager.self) { _ in
        //     NavigationManager.Shared
        // }.inObjectScope(.container) // Singleton
        
        // MARK: - Repositories
        // Example: Register Repositories
        // container.register(UserRepositoryProtocol.self) { resolver in
        //     let apiService = resolver.resolve(APIServiceProtocol.self)!
        //     return UserRepository(apiService: apiService)
        // }.inObjectScope(.transient)
    }
}

