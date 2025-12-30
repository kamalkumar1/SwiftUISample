//
//  AppAssembly.swift
//  SampleUI
//
//  Created by kamalkumar on 29/12/25.
//

import Foundation
import Swinject

/// Main Assembly class for organizing dependency registrations
/// This follows Swinject's recommended Assembly pattern
class AppAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Network Layer
        // Register network layer dependencies
        let networkAssembly = NetworkLayerAssembly()
        networkAssembly.assemble(container: container)
        
        // MARK: - Managers (Singleton - persist across logout)
        container.register(NavigationManager.self) { _ in
            NavigationManager.Shared
        }.inObjectScope(.container)
        
        // MARK: - ViewModels (Transient - new instance per view)
        // Example: Register ViewModels
        // container.register(LoginViewModel.self) { resolver in
        //     let authService = resolver.resolve(AuthServiceProtocol.self)!
        //     let navigationManager = resolver.resolve(NavigationManager.self)!
        //     return LoginViewModel(authService: authService, navigationManager: navigationManager)
        // }.inObjectScope(.transient)
        
        // MARK: - Additional Services
        // Add other app-level services here
    }
}

