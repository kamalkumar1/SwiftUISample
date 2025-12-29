# DI Container Architecture Guide

## Your Understanding is ✅ **CORRECT**!

This document confirms your understanding and provides implementation guidelines.

---

## Lifetime Types Explained

### 1. **Transient** 🔄
- **Behavior**: Creates a **new instance every time** it's resolved
- **Use Case**: ViewModels that follow MVVM lifecycle (created when view appears, destroyed when view disappears)
- **Example**: `LoginViewModel`, `SignUpViewModel`
- **Lifecycle**: Tied to SwiftUI view lifecycle

```swift
// Register
SwinjectDIContainer.registerTransient(LoginViewModel.self) { resolver in
    let authService = resolver.resolve(AuthServiceProtocol.self)!
    return LoginViewModel(authService: authService)
}

// Usage in View
struct LoginView: View {
    @StateObject private var viewModel = SwinjectDIContainer.resolve(LoginViewModel.self)
    // New instance created every time LoginView is created
}
```

---

### 2. **Singleton** 🏛️
- **Behavior**: Creates **one instance** when app starts, **persists until app closes**
- **Use Case**: Services that should **survive logout** (App-level services)
- **Example**: `NavigationManager`, `AnalyticsService`, `AppConfigService`
- **⚠️ Important**: Cannot be reset after registration - persists across logout/login

```swift
// Register (usually in App initialization)
SwinjectDIContainer.registerSingleton(NavigationManager.self) { _ in
    NavigationManager.Shared
}

SwinjectDIContainer.registerSingleton(AnalyticsService.self) { _ in
    AnalyticsService()
}

// Usage
let navManager = SwinjectDIContainer.resolve(NavigationManager.self)
// Same instance throughout app lifetime
```

**✅ Use Singleton for:**
- Navigation managers
- Analytics services
- App configuration
- Logging services
- Services that should persist after logout

**❌ Don't use Singleton for:**
- User-specific data
- ViewModels (use Transient or Scoped)
- Services that need to reset on logout

---

### 3. **Scoped** 🔐
- **Behavior**: Creates **one instance per scope**, maintains unique identity within scope
- **Use Case**: Services that should be **recreated on logout** (User-specific services)
- **Example**: `UserSession`, `UserProfileViewModel`, `HomeViewModel`
- **Lifecycle**: Persists during user session, **reset on logout**

```swift
// Register
SwinjectDIContainer.registerScoped(UserSession.self) { resolver in
    let apiService = resolver.resolve(APIServiceProtocol.self)!
    return UserSession(apiService: apiService)
}

SwinjectDIContainer.registerScoped(HomeViewModel.self) { resolver in
    let userSession = resolver.resolve(UserSession.self)!
    return HomeViewModel(userSession: userSession)
}

// Usage
let userSession = SwinjectDIContainer.resolve(UserSession.self)
// Same instance during user session

// On Logout - Reset scoped services
SwinjectDIContainer.onLogout()
// All scoped services are now cleared and will be recreated on next resolve
```

**✅ Use Scoped for:**
- User sessions
- User-specific ViewModels
- Services that depend on logged-in user
- Services that should reset on logout

**❌ Don't use Scoped for:**
- App-level services (use Singleton)
- ViewModels that should be recreated per view (use Transient)

---

## Architecture Pattern for Logout/Login

### Recommended Structure:

```
┌─────────────────────────────────────────┐
│         SINGLETON (App-Level)           │
│  - NavigationManager                    │
│  - AnalyticsService                     │
│  - AppConfigService                     │
│  - LoggingService                       │
│  ✅ Persists across logout/login         │
└─────────────────────────────────────────┘
              │
              │ (depends on)
              ▼
┌─────────────────────────────────────────┐
│         SCOPED (User Session)           │
│  - UserSession                          │
│  - HomeViewModel                        │
│  - ProfileViewModel                     │
│  ✅ Reset on logout, recreate on login    │
└─────────────────────────────────────────┘
              │
              │ (depends on)
              ▼
┌─────────────────────────────────────────┐
│         TRANSIENT (View Lifecycle)      │
│  - LoginViewModel                       │
│  - SignUpViewModel                      │
│  ✅ New instance per view creation      │
└─────────────────────────────────────────┘
```

---

## Implementation Example

### 1. **App Initialization** (AppDelegate or App struct)

```swift
@main
struct SampleUIApp: App {
    init() {
        setupDependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
    
    private func setupDependencies() {
        // SINGLETON - App-level services (persist across logout)
        SwinjectDIContainer.registerSingleton(NavigationManager.self) { _ in
            NavigationManager.Shared
        }
        
        SwinjectDIContainer.registerSingleton(AnalyticsService.self) { _ in
            AnalyticsService()
        }
        
        // SCOPED - User-specific services (reset on logout)
        SwinjectDIContainer.registerScoped(UserSession.self) { resolver in
            let apiService = resolver.resolve(APIServiceProtocol.self)!
            return UserSession(apiService: apiService)
        }
        
        SwinjectDIContainer.registerScoped(HomeViewModel.self) { resolver in
            let userSession = resolver.resolve(UserSession.self)!
            return HomeViewModel(userSession: userSession)
        }
        
        // TRANSIENT - View lifecycle services
        SwinjectDIContainer.registerTransient(LoginViewModel.self) { resolver in
            let authService = resolver.resolve(AuthServiceProtocol.self)!
            return LoginViewModel(authService: authService)
        }
    }
}
```

### 2. **Logout Implementation**

```swift
class AuthService {
    func logout() {
        // 1. Clear user data
        UserDefaults.standard.removeObject(forKey: "userToken")
        
        // 2. Reset all SCOPED services (ViewModels, UserSession, etc.)
        // This allows them to be recreated with fresh state on next login
        SwinjectDIContainer.onLogout()
        
        // 3. Navigate to login
        NavigationManager.Shared.resetPath()
        NavigationManager.Shared.path.append(PageName.SignIn)
        
        // Note: Singleton services (NavigationManager, AnalyticsService) remain intact
    }
}
```

### 3. **Login Implementation**

```swift
class LoginViewModel: ObservableObject {
    private let authService: AuthServiceProtocol
    
    func login(email: String, password: String) {
        // After successful login
        authService.login(email: email, password: password) { [weak self] success in
            if success {
                // Scoped services will be automatically created when resolved
                // No need to manually recreate - they're fresh now!
                NavigationManager.Shared.path.append(PageName.Home)
            }
        }
    }
}
```

---

## Decision Matrix

| Service Type | Lifetime | Reset on Logout? | Example |
|-------------|----------|------------------|---------|
| App Configuration | **Singleton** | ❌ No | `AppConfigService` |
| Navigation | **Singleton** | ❌ No | `NavigationManager` |
| Analytics | **Singleton** | ❌ No | `AnalyticsService` |
| User Session | **Scoped** | ✅ Yes | `UserSession` |
| User Profile | **Scoped** | ✅ Yes | `UserProfileViewModel` |
| Home Screen | **Scoped** | ✅ Yes | `HomeViewModel` |
| Login Screen | **Transient** | N/A | `LoginViewModel` |
| Sign Up Screen | **Transient** | N/A | `SignUpViewModel` |

---

## Verification Checklist

✅ **Your Understanding is Correct:**

1. ✅ **Transient** = New instance per view (MVVM lifecycle)
2. ✅ **Singleton** = One instance, persists until app closes, **cannot reset on logout**
3. ✅ **Scoped** = One instance per session, **can reset on logout** using `onLogout()`

✅ **Architecture Pattern:**
- Use **Singleton** for services that should persist after logout
- Use **Scoped** for services that should reset on logout
- Use **Transient** for ViewModels tied to view lifecycle

---

## Current Implementation Status

✅ **SwinjectDIContainer supports your architecture:**

1. ✅ `registerSingleton()` - Persists across logout
2. ✅ `registerScoped()` - Can be reset on logout
3. ✅ `registerTransient()` - New instance per resolve
4. ✅ `onLogout()` - Resets all scoped services
5. ✅ `startNewScope()` - Creates new scope for fresh instances

---

## Best Practices

1. **Register dependencies at app startup** (in App init or AppDelegate)
2. **Call `onLogout()` when user logs out** to reset scoped services
3. **Use Singleton sparingly** - only for truly app-level services
4. **Use Scoped for user-specific data** - automatically handles logout scenarios
5. **Use Transient for ViewModels** - follows SwiftUI lifecycle naturally

---

## Summary

Your understanding is **100% correct**! The SwinjectDIContainer implementation now fully supports your architecture pattern:

- ✅ Singleton persists across logout (for app-level services)
- ✅ Scoped can be reset on logout (for user-specific services)
- ✅ Transient creates new instances (for view lifecycle)

The implementation is ready for your enterprise app! 🚀

