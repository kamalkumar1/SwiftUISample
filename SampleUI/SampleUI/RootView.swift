//
//  RootView.swift
//  SampleUI
//
//  Created by kamalkumar on 27/12/25.
//

import SwiftUI

struct RootView: View {
    @ObservedObject private var navManager = NavigationManager.Shared
    var body: some View {
        NavigationStack(path: $navManager.path) {
            
            LoginView()
                .navigationDestination(for: PageName.self) { page in
                    switch page
                    {
                    case .SignUp:
                        SignUpView()
                    case .SignIn:
                        EmptyView()
                    case .PinScreen:
                       PinSetView()
                    case .ForgotPassword:
                        ForgotPassword()
                    case .Home:
                        EmptyView()
                    }
                }
                .sheet(item: $navManager.presentedPage, onDismiss: {
                    // Optional cleanup logic here
                    print("Sheet dismissed")
                    navManager.dismiss()
                    
                }) {  page in
                    
                    switch page
                    {
                        case .SignUp:
                            SignUpView()
                        case .ForgotPassword:
                            ForgotPassword()
                        default:
                            EmptyView()
                    }
                }
        }
    }
}

