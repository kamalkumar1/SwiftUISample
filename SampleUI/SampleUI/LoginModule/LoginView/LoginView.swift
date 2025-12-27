//
//  LoginView.swift
//  SampleUI
//
//  Created by kamalkumar on 24/12/25.
//

import SwiftUI

struct LoginView: View {
   
   
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var topFrame: CGRect = .zero
    @State private var loginFrame: CGRect = .zero
    
    var body: some View {
        VStack(alignment: .center){
            // 1. BACKGROUND FIRST (bottom layer)
            GradientBackgroundView()
            // 2. LoginCard OVERLAY (top layer)
            
        }
        .overlay(LoginCardView())
    
    }
        
        
}

#Preview {
    LoginView()
}
