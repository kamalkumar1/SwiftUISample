//
//  LoginCardView.swift
//  SampleUI
//
//  Created by kamalkumar on 25/12/25.
//

import SwiftUI

struct LoginCardView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    var body: some View {
        VStack(alignment: .center, spacing: 12){
            TopView()
            VStack(spacing:0){
                // Placeholder and TextField code...
            
              
                TextField("Email", text: $email)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                    .padding(.top, 30)
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                   
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                    .padding(.top, 24)
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                
                ForgotPasswordButton(title: "Forgot Password?") {
                    
                    NavigationManager.Shared.present(PageName.ForgotPassword)
                    
                }
                .padding(.top, 4)
                .padding(.bottom, 8)
                .padding(.trailing, 12)
                CommonButton {
                    NavigationManager.Shared.moveToPinScreen()
                }
                .padding(.trailing, 12)
                .padding(.leading, 12)
                .padding(.bottom, 20)
                HStack(spacing: 1) {
                    Text("Don't have an account?")
                        .font(.system(size: 12))
                        .foregroundColor(.gray).bold()
                    Text("Sign Up")
                        .font(.system(size: 13))
                        .foregroundColor(.blue).bold()
                    // optional, makes it stand out
                }.padding(.bottom, 14)
                    .onTapGesture {
                        print("signup is tapped")
                        NavigationManager.Shared.moveToSignUpPage()
                    }
               
                Text("Or login with")
                    .foregroundStyle(Color.gray)
                    .font(Font.caption.bold())
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                
                GoogleButton { print("Google button tapped in preview") }
                    .padding(.top,20)
                    .padding(.bottom,30)
                
            }.frame(alignment:  .top)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.gray.opacity(0.5), radius: 10, x: 0, y: 10)
                .padding(.horizontal, 24).overlay(
                    GeometryReader { geo in
                        Color.clear.preference(key:CommonPreferenceKeys.LoginCardFrame.self,
                                               value: geo.frame(in: .local))
                    }
                )
            Color.clear.frame(height: 30)
        }
        
        

    }
    
}

#Preview {
    LoginCardView()
}
