//
//  DISetup.swift
//  SampleUI
//
//  Created by kamalkumar on 29/12/25.
//

import Foundation

enum Lifetime {
    case singleton
    case scoped
    case transient
}

class DIContainer {
    // MARK: - Singleton Instance
    static let shared = DIContainer()
    
    // MARK: - Private Properties
    private var singletons: [ObjectIdentifier: Any] = [:]
    private var scopedInstances: [String: Any] = [:]  // "sessionId-typeId"
    private var factories: [ObjectIdentifier: Factory] = [:]
    private var lifetimes: [ObjectIdentifier: Lifetime] = [:]
    private var currentSessionId = UUID().uuidString
    
    typealias Factory = (DIContainer) -> Any
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Registration Methods
    /// Register a singleton service - cached once for the lifetime of the container
    static func registerSingleton<T>(_ type: T.Type, implementation: @escaping () -> T) {
        let key = ObjectIdentifier(type)
        DIContainer.shared.factories[key] = { _ in implementation() }
        DIContainer.shared.lifetimes[key] = .singleton
    }
    
    /// Register a scoped service - cached per session/scope
    static func registerScoped<T>(_ type: T.Type, implementation: @escaping (DIContainer) -> T) {
        let key = ObjectIdentifier(type)
        DIContainer.shared.factories[key] = implementation
        DIContainer.shared.lifetimes[key] = .scoped
    }
    
    /// Register a transient service - new instance every time (never cached)
    static func registerTransient<T>(_ type: T.Type, implementation: @escaping (DIContainer) -> T) {
        let key = ObjectIdentifier(type)
        DIContainer.shared.factories[key] = implementation
        DIContainer.shared.lifetimes[key] = .transient
    }
    
    // MARK: - Resolution Method
    /// Resolve a service instance based on its registered lifetime
    static func resolve<T>(_ type: T.Type) -> T {
        let key = ObjectIdentifier(type)
        let container = DIContainer.shared
        
        // Get lifetime for this registration
        guard let lifetime = container.lifetimes[key] else {
            fatalError("❌ No registration for \(type)")
        }
        
        // 1️⃣ SINGLETON - check cache first
        if lifetime == .singleton {
            if let singleton = container.singletons[key] as? T {
                return singleton
            }
        }
        
        // 2️⃣ SCOPED - check cache for current session
        if lifetime == .scoped {
            let scopeKey = "\(container.currentSessionId)-\(String(describing: key))"
            if let scoped = container.scopedInstances[scopeKey] as? T {
                return scoped
            }
        }
        
        // 3️⃣ FACTORY - create new instance
        guard let factory = container.factories[key] else {
            fatalError("❌ No factory found for \(type)")
        }
        
        let instance = factory(container) as! T
        
        // 4️⃣ CACHE based on lifetime
        switch lifetime {
        case .singleton:
            container.singletons[key] = instance
        case .scoped:
            let scopeKey = "\(container.currentSessionId)-\(String(describing: key))"
            container.scopedInstances[scopeKey] = instance
        case .transient:
            // Transient services are never cached
            break
        }
        
        return instance
    }
    
    // MARK: - Session Management
    /// Start a new scope - clears old scoped instances
    static func startNewScope() {
        DIContainer.shared.scopedInstances = [:]
        DIContainer.shared.currentSessionId = UUID().uuidString
    }
    
    /// Reset all scoped instances
    static func resetScoped() {
        DIContainer.shared.scopedInstances = [:]
    }
    
    /// Reset everything for testing purposes
    static func resetForTesting() {
        DIContainer.shared.singletons = [:]
        DIContainer.shared.scopedInstances = [:]
        DIContainer.shared.factories = [:]
        DIContainer.shared.lifetimes = [:]
        DIContainer.shared.currentSessionId = UUID().uuidString
    }
}

