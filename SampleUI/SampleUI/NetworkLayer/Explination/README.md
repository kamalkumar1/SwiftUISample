# Network Layer Architecture

## Overview
This network layer provides a clean, testable, and maintainable architecture for handling all network requests in the application.

## Architecture

```
NetworkLayer/
├── NetworkError.swift              # Error types
├── NetworkRequest.swift            # Request protocol & builder
├── NetworkConfiguration.swift     # Configuration manager
├── NetworkClientProtocol.swift     # Client protocol
├── NetworkClient.swift             # Client implementation
├── APIEndpoints.swift              # API endpoint definitions
├── NetworkLayerAssembly.swift      # DI registration
├── Models/                         # Response models
│   └── AuthModels.swift
└── Services/                       # Service layer
    ├── AuthServiceProtocol.swift
    ├── AuthService.swift
    ├── UserServiceProtocol.swift
    └── UserService.swift
```

## Features

✅ **Async/Await Support** - Modern Swift concurrency
✅ **Combine Support** - Reactive programming
✅ **Protocol-Based** - Easy to mock for testing
✅ **Error Handling** - Comprehensive error types
✅ **Logging** - Request/Response logging (debug mode)
✅ **Token Management** - Automatic authorization header
✅ **DI Integration** - Swinject integration ready

## Usage

### 1. Setup in App Initialization

```swift
@main
struct SampleUIApp: App {
    init() {
        // Register network layer
        SwinjectDIContainer.registerAssembly(NetworkLayerAssembly())
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
```

### 2. Use in ViewModel (Async/Await)

```swift
class LoginViewModel: ObservableObject {
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func login(email: String, password: String) async {
        do {
            let response = try await authService.login(email: email, password: password)
            // Handle success
            print("Login successful: \(response.user.name)")
        } catch let error as NetworkError {
            // Handle error
            print("Login failed: \(error.localizedDescription)")
        }
    }
}
```

### 3. Use in ViewModel (Combine)

```swift
class LoginViewModel: ObservableObject {
    private let authService: AuthServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
    
    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil
        
        authService.loginPublisher(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    // Handle success
                    print("Login successful: \(response.user.name)")
                }
            )
            .store(in: &cancellables)
    }
}
```

### 4. Resolve from DI Container

```swift
// In ViewModel initialization
let authService = SwinjectDIContainer.resolve(AuthServiceProtocol.self)
let viewModel = LoginViewModel(authService: authService)
```

## Error Handling

```swift
do {
    let response = try await authService.login(email: email, password: password)
} catch NetworkError.unauthorized {
    // Handle 401 - redirect to login
} catch NetworkError.networkUnavailable {
    // Handle no internet
} catch NetworkError.timeout {
    // Handle timeout
} catch let error as NetworkError {
    // Handle other network errors
    print(error.localizedDescription)
}
```

## Configuration

Edit `NetworkConfiguration.swift` to:
- Change base URL (dev/prod)
- Add API keys
- Configure timeout
- Enable/disable logging

## Adding New Endpoints

1. Add endpoint to `APIEndpoints` enum
2. Create request/response models in `Models/`
3. Add service method in protocol and implementation
4. Register in `NetworkLayerAssembly` if needed

## Testing

Mock the protocols for unit testing:

```swift
class MockAuthService: AuthServiceProtocol {
    var loginResult: Result<LoginResponse, NetworkError>?
    
    func login(email: String, password: String) async throws -> LoginResponse {
        if let result = loginResult {
            switch result {
            case .success(let response):
                return response
            case .failure(let error):
                throw error
            }
        }
        throw NetworkError.unknown(NSError())
    }
    // ... implement other methods
}
```

## Best Practices

1. ✅ Always use protocols for services (easy to mock)
2. ✅ Handle errors appropriately in ViewModels
3. ✅ Use async/await for new code
4. ✅ Keep models in separate files
5. ✅ Register services as Scoped (reset on logout)
6. ✅ Register NetworkClient as Singleton

