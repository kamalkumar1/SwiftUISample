//
//  DIContainerUsageExample.swift
//  SampleUI
//
//  Created by kamalkumar on 29/12/25.
//
//  This file demonstrates how to use SwinjectDIContainer
//  You can delete this file once you understand the usage

import Foundation
import Swinject

// MARK: - Example Usage

/*
 
 // MARK: - 1. Setup (usually in AppDelegate or App initialization)
 
 // Option A: Register services individually
 SwinjectDIContainer.registerSingleton(NavigationManager.self) { _ in
     NavigationManager.Shared
 }
 
 SwinjectDIContainer.registerTransient(LoginViewModel.self) { resolver in
     let navManager = resolver.resolve(NavigationManager.self)!
     return LoginViewModel(navigationManager: navManager)
 }
 
 // Option B: Use Assembly pattern (recommended for larger apps)
 SwinjectDIContainer.registerAssembly(AppAssembly())
 
 // MARK: - 2. Resolve dependencies
 
 // In your View or ViewModel:
 let navManager = SwinjectDIContainer.resolve(NavigationManager.self)
 let loginViewModel = SwinjectDIContainer.resolve(LoginViewModel.self)
 
 // Safe resolution (returns nil if not registered):
 if let optionalService = SwinjectDIContainer.resolveOptional(SomeService.self) {
     // Use service
 }
 
 // MARK: - 3. Scoped Services
 
 // Start a new scope (e.g., when user logs in)
 SwinjectDIContainer.startNewScope()
 
 // Resolve scoped services
 let scopedService = SwinjectDIContainer.resolveScoped(UserSession.self)
 
 // MARK: - 4. Named Registrations (multiple implementations)
 
 // Register multiple implementations
 SwinjectDIContainer.registerNamed(APIServiceProtocol.self, name: "production") { _ in
     ProductionAPIService()
 }
 
 SwinjectDIContainer.registerNamed(APIServiceProtocol.self, name: "mock") { _ in
     MockAPIService()
 }
 
 // Resolve by name
 let productionAPI = SwinjectDIContainer.resolve(APIServiceProtocol.self, name: "production")
 let mockAPI = SwinjectDIContainer.resolve(APIServiceProtocol.self, name: "mock")
 
 // MARK: - 5. Testing
 
 // Reset container for testing
 SwinjectDIContainer.resetForTesting()
 
 */

