//
//  ForgotPasswordButton.swift
//  SampleUI
//
//  Created by kamalkumar on 25/12/25.
//


//
//  TapButton.swift
//  SampleUI
//
//  Created by kamalkumar on 25/12/25.
//

import SwiftUI

struct ForgotPasswordButton: View {
    var title: String
    var icon: String? = nil   // optional SF Symbol
    var backgroundColor: Color = .red
    var foregroundColor: Color = .blue
    var action: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
               Text(title)
                
                .font(.system(size: 13, weight: .bold)) .foregroundColor(.blue) 
        }
        .frame(height: 44)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .onTapGesture {
                  action()
          }
        }
    }
#Preview {
    ForgotPasswordButton(title: "Forgot Password?") {
        
    }
}

