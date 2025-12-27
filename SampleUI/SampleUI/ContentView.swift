//
//  ContentView.swift
//  SampleUI
//
//  Created by kamalkumar on 24/12/25.
//

import SwiftUI

import SwiftUI
struct HalfBlueHalfWhiteBackground: View {
    var body: some View {
        ZStack {
            // Background: top half blue, bottom half white
            VStack(spacing: 0) {
                Color.blue          // top half
                Color.white         // bottom half
            }
            .ignoresSafeArea()      // fill under notch / home indicator

            // Your foreground content here
            LoginView1()             // or any other content
        }
    }
}


struct LoginView1: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var showPassword: Bool = false

    var body: some View {
        VStack(spacing: 16) {

            // Top content
            VStack(spacing: 8) {
                Image(systemName: "shield.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)

                Text("Sign in to your")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                Text("Account")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)

                Text("Enter your email and password to log in")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(.top, 40)

            Spacer()

            // CARD VIEW
            VStack(spacing: 20) {

                // Google button (simplified)
                Button { } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "g.circle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 20))
                        Text("Continue with Google")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.96, green: 0.97, blue: 0.98))
                    )
                }
                .buttonStyle(.plain)
                .padding(.top, 16)

                // Email field
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding(.horizontal, 16)
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.93, green: 0.95, blue: 0.96))
                    )

                // Password field
                HStack {
                    if showPassword {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 16)
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.93, green: 0.95, blue: 0.96))
                )

                // Log In button
                Button { } label: {
                    Text("Log In")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.12, green: 0.50, blue: 0.99),
                                         Color(red: 0.08, green: 0.38, blue: 0.90)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(14)
                }
                .padding(.top, 10)

            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.red)
            )
            .padding(.horizontal, 16)

            Spacer()
        }
    }
}


#Preview {
    HalfBlueHalfWhiteBackground()
    //LoginView1()
}
