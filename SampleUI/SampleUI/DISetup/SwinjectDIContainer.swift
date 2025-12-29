//
//  SwinjectDIContainer.swift
//  SampleUI
//
//  Created by kamalkumar on 29/12/25.
//

import Foundation
import Swinject

/// Swinject-based Dependency Injection Container
/// Provides a clean API wrapper around Swinject for dependency injection
class SwinjectDIContainer {
    // MARK: - Singleton Instance
    static let shared = SwinjectDIContainer()
    
    // MARK: - Private Properties
    private let container: Container
    private var scopedContainers: [String: Container] = [:]
    private var currentScopeId: String = UUID().uuidString
    
    // MARK: - Initialization
    private init() {
        container = Container()
        setupDefaultRegistrations()
    }
    
    // MARK: - Container Access
    /// Get the main container instance
    var mainContainer: Container {
        return container
    }
    
    /// Get or create a scoped container for the current scope
    var scopedContainer: Container {
        if let existing = scopedContainers[currentScopeId] {
            return existing
        }
        let newContainer = Container(parent: container)
        scopedContainers[currentScopeId] = newContainer
        return newContainer
    }
    
    // MARK: - Registration Methods
    /// Register a singleton service - cached once for the lifetime of the container
    static func registerSingleton<Service>(
        _ serviceType: Service.Type,
        factory: @escaping (Resolver) -> Service
    ) {
        SwinjectDIContainer.shared.container.register(serviceType) { resolver in
            factory(resolver)
        }.inObjectScope(.container)
    }
    
    /// Register a scoped service - cached per session/scope
    /// Scoped services are recreated when startNewScope() is called (e.g., on logout)
    static func registerScoped<Service>(
        _ serviceType: Service.Type,
        factory: @escaping (Resolver) -> Service
    ) {
        // Register in main container but use .graph scope so it's cached per resolution graph
        // This allows it to be reset when scoped container is cleared
        SwinjectDIContainer.shared.container.register(serviceType) { resolver in
            factory(resolver)
        }.inObjectScope(.graph)
    }
    
    /// Register a scoped service in the scoped container (better for logout scenarios)
    /// This service will be completely recreated when startNewScope() is called
    static func registerScopedInScope<Service>(
        _ serviceType: Service.Type,
        factory: @escaping (Resolver) -> Service
    ) {
        // Register in the current scoped container
        // This ensures the service is recreated on logout
        SwinjectDIContainer.shared.scopedContainer.register(serviceType) { resolver in
            factory(resolver)
        }.inObjectScope(.container)
    }
    
    /// Register a transient service - new instance every time (never cached)
    static func registerTransient<Service>(
        _ serviceType: Service.Type,
        factory: @escaping (Resolver) -> Service
    ) {
        SwinjectDIContainer.shared.container.register(serviceType) { resolver in
            factory(resolver)
        }.inObjectScope(.transient)
    }
    
    /// Register a service with a name (useful for multiple implementations of the same protocol)
    static func registerNamed<Service>(
        _ serviceType: Service.Type,
        name: String,
        factory: @escaping (Resolver) -> Service
    ) {
        SwinjectDIContainer.shared.container.register(serviceType, name: name) { resolver in
            factory(resolver)
        }
    }
    
    // MARK: - Resolution Methods
    /// Resolve a service instance
    static func resolve<Service>(_ serviceType: Service.Type) -> Service {
        guard let service = SwinjectDIContainer.shared.container.resolve(serviceType) else {
            fatalError("❌ No registration found for \(serviceType)")
        }
        return service
    }
    
    /// Resolve a service instance with a name
    static func resolve<Service>(_ serviceType: Service.Type, name: String) -> Service {
        guard let service = SwinjectDIContainer.shared.container.resolve(serviceType, name: name) else {
            fatalError("❌ No registration found for \(serviceType) with name: \(name)")
        }
        return service
    }
    
    /// Safely resolve a service (returns nil if not registered)
    static func resolveOptional<Service>(_ serviceType: Service.Type) -> Service? {
        return SwinjectDIContainer.shared.container.resolve(serviceType)
    }
    
    /// Resolve a service from the scoped container
    static func resolveScoped<Service>(_ serviceType: Service.Type) -> Service {
        guard let service = SwinjectDIContainer.shared.scopedContainer.resolve(serviceType) else {
            fatalError("❌ No scoped registration found for \(serviceType)")
        }
        return service
    }
    
    // MARK: - Assembly Pattern Support
    /// Register an assembly (Swinject's recommended pattern for organizing registrations)
    static func registerAssembly(_ assembly: Assembly) {
        assembly.assemble(container: SwinjectDIContainer.shared.container)
    }
    
    /// Register multiple assemblies
    static func registerAssemblies(_ assemblies: [Assembly]) {
        assemblies.forEach { assembly in
            assembly.assemble(container: SwinjectDIContainer.shared.container)
        }
    }
    
    // MARK: - Session/Scope Management
    /// Start a new scope - creates a new scoped container
    /// Call this on logout to reset all scoped services (ViewModels, UserSession, etc.)
    /// Singleton services will remain intact
    static func startNewScope() {
        // Clear all existing scoped containers (this releases all scoped instances)
        SwinjectDIContainer.shared.scopedContainers.removeAll()
        // Create a new scope ID for the new session
        SwinjectDIContainer.shared.currentScopeId = UUID().uuidString
    }
    
    /// Clear all scoped containers (same as startNewScope)
    /// Use this when user logs out to reset user-specific services
    static func resetScoped() {
        startNewScope()
    }
    
    /// Logout helper - resets all scoped services while keeping singletons
    /// This is the recommended method to call on user logout
    static func onLogout() {
        resetScoped()
    }
    
    /// Reset everything for testing purposes
    static func resetForTesting() {
        SwinjectDIContainer.shared.container.removeAll()
        SwinjectDIContainer.shared.scopedContainers.removeAll()
        SwinjectDIContainer.shared.currentScopeId = UUID().uuidString
    }
    
    // MARK: - Default Registrations
    private func setupDefaultRegistrations() {
        // Add any default registrations here
        // Example: container.register(SomeService.self) { _ in SomeServiceImpl() }
    }
}

// MARK: - Convenience Extensions
extension SwinjectDIContainer {
    /// Register a singleton with a simple factory (no resolver needed)
    static func registerSingleton<Service>(
        _ serviceType: Service.Type,
        factory: @escaping () -> Service
    ) {
        registerSingleton(serviceType) { _ in factory() }
    }
    
    /// Register a scoped service with a simple factory (no resolver needed)
    static func registerScoped<Service>(
        _ serviceType: Service.Type,
        factory: @escaping () -> Service
    ) {
        registerScoped(serviceType) { _ in factory() }
    }
    
    /// Register a scoped service in scoped container with simple factory
    static func registerScopedInScope<Service>(
        _ serviceType: Service.Type,
        factory: @escaping () -> Service
    ) {
        registerScopedInScope(serviceType) { _ in factory() }
    }
    
    /// Register a transient service with a simple factory (no resolver needed)
    static func registerTransient<Service>(
        _ serviceType: Service.Type,
        factory: @escaping () -> Service
    ) {
        registerTransient(serviceType) { _ in factory() }
    }
}

