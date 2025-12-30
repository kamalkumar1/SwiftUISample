//
//  LoginViewModelExample.swift
//  SampleUI
//
//  Created by kamalkumar on 29/12/25.
//
//  This is an example showing how to use the network layer in a ViewModel
//  You can delete this file once you understand the pattern

import Foundation
import SwiftUI
import Combine

/// Example ViewModel using the network layer with Async/Await
class LoginViewModelExample: ObservableObject {
    // MARK: - Published Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false
    
    // MARK: - Dependencies
    private let authService: AuthServiceProtocol
    private let navigationManager: NavigationManager
    
    // MARK: - Initialization
    init(
        authService: AuthServiceProtocol,
        navigationManager: NavigationManager
    ) {
        self.authService = authService
        self.navigationManager = navigationManager
    }
    
    // MARK: - Public Methods
    
    /// Login using Async/Await
    @MainActor
    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await authService.login(email: email, password: password)
            
            // Handle successful login
            isLoggedIn = true
            print("Login successful: \(response.user.name)")
            
            // Navigate to home
            navigationManager.path.append(PageName.Home)
            
        } catch let error as NetworkError {
            // Handle network errors
            switch error {
            case .unauthorized:
                errorMessage = "Invalid email or password"
            case .networkUnavailable:
                errorMessage = "No internet connection. Please check your network."
            case .timeout:
                errorMessage = "Request timeout. Please try again."
            default:
                errorMessage = error.localizedDescription
            }
        } catch {
            errorMessage = "An unexpected error occurred"
        }
        
        isLoading = false
    }
    
    /// Sign up using Async/Await
    @MainActor
    func signup(name: String) async {
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty else {
            errorMessage = "Please fill all fields"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await authService.signup(name: name, email: email, password: password)
            
            // Handle successful signup
            isLoggedIn = true
            print("Signup successful: \(response.user.name)")
            
            // Navigate to home
            navigationManager.path.append(PageName.Home)
            
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "An unexpected error occurred"
        }
        
        isLoading = false
    }
}

/// Example ViewModel using Combine (Alternative approach)
class LoginViewModelCombineExample: ObservableObject {
    // MARK: - Published Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false
    
    // MARK: - Dependencies
    private let authService: AuthServiceProtocol
    private let navigationManager: NavigationManager
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(
        authService: AuthServiceProtocol,
        navigationManager: NavigationManager
    ) {
        self.authService = authService
        self.navigationManager = navigationManager
    }
    
    // MARK: - Public Methods
    
    /// Login using Combine
    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        authService.loginPublisher(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    
                    // Handle successful login
                    self.isLoggedIn = true
                    print("Login successful: \(response.user.name)")
                    
                    // Navigate to home
                    self.navigationManager.path.append(PageName.Home)
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    
    private func handleError(_ error: NetworkError) {
        switch error {
        case .unauthorized:
            errorMessage = "Invalid email or password"
        case .networkUnavailable:
            errorMessage = "No internet connection. Please check your network."
        case .timeout:
            errorMessage = "Request timeout. Please try again."
        default:
            errorMessage = error.localizedDescription
        }
    }
}

/// Example usage in View
struct LoginViewExample: View {
    // Resolve dependencies from DI Container
    @StateObject private var viewModel = {
        let authService = SwinjectDIContainer.resolve(AuthServiceProtocol.self)
        let navManager = SwinjectDIContainer.resolve(NavigationManager.self)
        return LoginViewModelExample(authService: authService, navigationManager: navManager)
    }()
    
    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
            SecureField("Password", text: $viewModel.password)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Button("Login") {
                Task {
                    await viewModel.login()
                }
            }
            .disabled(viewModel.isLoading)
            
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}

