//
//  NetworkLayerAssembly.swift
//  SampleUI
//
//  Created by kamalkumar on 29/12/25.
//

import Foundation
import Swinject

/// Assembly for registering network layer dependencies
class NetworkLayerAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - Network Configuration (Singleton)
        container.register(NetworkConfiguration.self) { _ in
            NetworkConfiguration.shared
        }.inObjectScope(.container)
        
        // MARK: - Network Client (Singleton)
        container.register(NetworkClientProtocol.self) { resolver in
            let configuration = resolver.resolve(NetworkConfiguration.self)!
            return NetworkClient(configuration: configuration)
        }.inObjectScope(.container)
        
        // MARK: - Services (Scoped - reset on logout)
        container.register(AuthServiceProtocol.self) { resolver in
            let networkClient = resolver.resolve(NetworkClientProtocol.self)!
            return AuthService(networkClient: networkClient)
        }.inObjectScope(.graph)
        
        container.register(UserServiceProtocol.self) { resolver in
            let networkClient = resolver.resolve(NetworkClientProtocol.self)!
            return UserService(networkClient: networkClient)
        }.inObjectScope(.graph)
    }
}

