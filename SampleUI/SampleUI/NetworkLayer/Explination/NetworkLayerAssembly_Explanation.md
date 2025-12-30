# NetworkLayerAssembly Class - Detailed Explanation

## Overview
`NetworkLayerAssembly` is a **Swinject Assembly** class that registers all network layer dependencies into the Dependency Injection (DI) container. It follows the **Assembly Pattern**, which is Swinject's recommended way to organize dependency registrations.

---

## What is an Assembly?

An **Assembly** is a class that groups related dependencies together. It acts as a "module" or "feature" that can be registered with the DI container.**

### Benefits:
- ✅ **Organization** - Groups related dependencies
- ✅ **Modularity** - Can register/unregister entire features
- ✅ **Testability** - Easy to swap assemblies for testing
- ✅ **Maintainability** - Clear separation of concerns

---

## Class Structure Breakdown

```swift
class NetworkLayerAssembly: Assembly {
    func assemble(container: Container) {
        // Register dependencies here
    }
}
```

### Key Components:

1. **Conforms to `Assembly` protocol** - Swinject's protocol for dependency registration
2. **`assemble(container:)` method** - Called to register all dependencies
3. **`container` parameter** - The DI container where dependencies are registered

---

## Line-by-Line Explanation

### 1. Network Configuration (Singleton)

```swift
// MARK: - Network Configuration (Singleton)
container.register(NetworkConfiguration.self) { _ in
    NetworkConfiguration.shared
}.inObjectScope(.container)
```

**What it does:**
- Registers `NetworkConfiguration` as a **Singleton**
- Returns the shared instance (`NetworkConfiguration.shared`)

**Why Singleton:**
- ✅ Configuration doesn't change during app lifetime
- ✅ Single source of truth for API URLs, timeouts, etc.
- ✅ No need to recreate - same instance everywhere

**Usage:**
```swift
let config = SwinjectDIContainer.resolve(NetworkConfiguration.self)
// Always returns the same instance
```

---

### 2. Network Client (Singleton)

```swift
// MARK: - Network Client (Singleton)
container.register(NetworkClientProtocol.self) { resolver in
    let configuration = resolver.resolve(NetworkConfiguration.self)!
    return NetworkClient(configuration: configuration)
}.inObjectScope(.container)
```

**What it does:**
- Registers `NetworkClientProtocol` (not concrete `NetworkClient`)
- Uses **dependency injection** - resolves `NetworkConfiguration` from container
- Creates `NetworkClient` with the resolved configuration
- Marked as **Singleton** (`.container` scope)

**Why Protocol:**
- ✅ Testability - Can mock `NetworkClientProtocol` in tests
- ✅ Flexibility - Can swap implementations
- ✅ Dependency Inversion Principle

**Why Singleton:**
- ✅ Network client is stateless (except token)
- ✅ Reusing same instance is efficient
- ✅ Token management is centralized

**Dependency Chain:**
```
NetworkClientProtocol
    └── depends on ──> NetworkConfiguration
```

**Usage:**
```swift
let networkClient = SwinjectDIContainer.resolve(NetworkClientProtocol.self)
// Always returns the same instance with same configuration
```

---

### 3. Auth Service (Scoped)

```swift
// MARK: - Services (Scoped - reset on logout)
container.register(AuthServiceProtocol.self) { resolver in
    let networkClient = resolver.resolve(NetworkClientProtocol.self)!
    return AuthService(networkClient: networkClient)
}.inObjectScope(.graph)
```

**What it does:**
- Registers `AuthServiceProtocol` (not concrete `AuthService`)
- Resolves `NetworkClientProtocol` from container
- Creates `AuthService` with the network client
- Marked as **Scoped** (`.graph` scope)

**Why Protocol:**
- ✅ Testability - Easy to mock for unit tests
- ✅ Flexibility - Can swap implementations

**Why Scoped (not Singleton):**
- ✅ **Resets on logout** - Fresh instance after user logs out
- ✅ User-specific state can be cleared
- ✅ Better for user session management

**Dependency Chain:**
```
AuthServiceProtocol
    └── depends on ──> NetworkClientProtocol
            └── depends on ──> NetworkConfiguration
```

**Usage:**
```swift
let authService = SwinjectDIContainer.resolve(AuthServiceProtocol.self)
// New instance per scope (resets on logout)
```

---

### 4. User Service (Scoped)

```swift
container.register(UserServiceProtocol.self) { resolver in
    let networkClient = resolver.resolve(NetworkClientProtocol.self)!
    return UserService(networkClient: networkClient)
}.inObjectScope(.graph)
```

**What it does:**
- Same pattern as `AuthService`
- Registers `UserServiceProtocol`
- Resolves `NetworkClientProtocol` dependency
- Marked as **Scoped**

**Why Scoped:**
- ✅ User-specific operations
- ✅ Resets on logout
- ✅ Fresh state for new user session

---

## Object Scopes Explained

### `.container` (Singleton)
- **Lifetime**: App lifetime
- **Instance**: One instance, shared everywhere
- **Use for**: Configuration, managers, stateless services
- **Example**: `NetworkConfiguration`, `NetworkClient`

### `.graph` (Scoped)
- **Lifetime**: Per resolution graph (or until scope reset)
- **Instance**: One instance per scope
- **Use for**: User-specific services
- **Example**: `AuthService`, `UserService`
- **Resets**: When `SwinjectDIContainer.onLogout()` is called

### `.transient`
- **Lifetime**: Per resolution
- **Instance**: New instance every time
- **Use for**: ViewModels, request handlers
- **Example**: `LoginViewModel`, `SignUpViewModel`

---

## How It Works - Registration Flow

### Step 1: Assembly Registration
```swift
// In App initialization
SwinjectDIContainer.registerAssembly(NetworkLayerAssembly())
```

### Step 2: Assembly Execution
```swift
// Swinject calls:
let assembly = NetworkLayerAssembly()
assembly.assemble(container: SwinjectDIContainer.shared.container)
```

### Step 3: Dependencies Registered
```
Container now has:
├── NetworkConfiguration (Singleton)
├── NetworkClientProtocol → NetworkClient (Singleton)
├── AuthServiceProtocol → AuthService (Scoped)
└── UserServiceProtocol → UserService (Scoped)
```

### Step 4: Dependency Resolution
```swift
// When you request AuthService:
let authService = SwinjectDIContainer.resolve(AuthServiceProtocol.self)

// Swinject automatically:
// 1. Creates NetworkClient (if not exists)
// 2. Resolves NetworkConfiguration (if not exists)
// 3. Injects NetworkClient into AuthService
// 4. Returns AuthService instance
```

---

## Dependency Graph Visualization

```
┌─────────────────────────────────────────┐
│      NetworkLayerAssembly               │
│                                          │
│  ┌──────────────────────────────────┐   │
│  │ NetworkConfiguration (Singleton) │   │
│  │ - baseURL                         │   │
│  │ - timeout                         │   │
│  └──────────────┬───────────────────┘   │
│                 │                        │
│                 ▼                        │
│  ┌──────────────────────────────────┐   │
│  │ NetworkClientProtocol (Singleton) │   │
│  │ - session                         │   │
│  │ - token management               │   │
│  └──────────────┬───────────────────┘   │
│                 │                        │
│        ┌────────┴────────┐              │
│        │                  │              │
│        ▼                  ▼              │
│  ┌─────────────┐  ┌─────────────┐      │
│  │AuthService  │  │UserService  │      │
│  │(Scoped)     │  │(Scoped)     │      │
│  └─────────────┘  └─────────────┘      │
└─────────────────────────────────────────┘
```

---

## Real-World Usage Example

### 1. App Initialization
```swift
@main
struct SampleUIApp: App {
    init() {
        // Register network layer
        SwinjectDIContainer.registerAssembly(NetworkLayerAssembly())
    }
}
```

### 2. In ViewModel
```swift
class LoginViewModel: ObservableObject {
    private let authService: AuthServiceProtocol
    
    init() {
        // Resolve from DI container
        self.authService = SwinjectDIContainer.resolve(AuthServiceProtocol.self)
    }
    
    func login(email: String, password: String) async {
        // Use the service
        let response = try await authService.login(email: email, password: password)
    }
}
```

### 3. On Logout
```swift
func logout() {
    // Reset scoped services (AuthService, UserService get new instances)
    SwinjectDIContainer.onLogout()
    
    // Singleton services (NetworkClient, NetworkConfiguration) remain
}
```

---

## Benefits of This Architecture

### 1. **Separation of Concerns**
- Network layer dependencies are isolated
- Easy to find and modify network-related registrations

### 2. **Testability**
```swift
// In tests, you can create a test assembly
class TestNetworkLayerAssembly: Assembly {
    func assemble(container: Container) {
        // Register mock implementations
        container.register(NetworkClientProtocol.self) { _ in
            MockNetworkClient()
        }
    }
}
```

### 3. **Modularity**
- Can register/unregister entire network layer
- Easy to swap implementations
- Can have multiple assemblies

### 4. **Dependency Injection**
- Dependencies are automatically resolved
- No manual object creation
- Loose coupling

---

## Common Patterns

### Pattern 1: Register Protocol, Return Implementation
```swift
container.register(Protocol.self) { resolver in
    return Implementation(resolver: resolver)
}
```
**Why**: Testability, flexibility

### Pattern 2: Resolve Dependencies
```swift
container.register(Service.self) { resolver in
    let dependency = resolver.resolve(Dependency.self)!
    return Service(dependency: dependency)
}
```
**Why**: Automatic dependency injection

### Pattern 3: Singleton for Stateless Services
```swift
container.register(Service.self) { _ in
    return Service()
}.inObjectScope(.container)
```
**Why**: Efficiency, single instance

### Pattern 4: Scoped for User-Specific Services
```swift
container.register(Service.self) { resolver in
    return Service()
}.inObjectScope(.graph)
```
**Why**: Reset on logout, fresh state

---

## Summary

**NetworkLayerAssembly** is a **dependency registration module** that:

1. ✅ **Organizes** network layer dependencies
2. ✅ **Registers** services with proper lifetimes
3. ✅ **Injects** dependencies automatically
4. ✅ **Separates** concerns (network layer isolated)
5. ✅ **Enables** testing (easy to mock)
6. ✅ **Supports** logout scenarios (scoped services reset)

**Key Takeaway**: This class is the "wiring" that connects all network layer components together through dependency injection, making the code testable, maintainable, and flexible.

