//
//  GoogleLoginButton.swift
//  SampleUI
//
//  Created by kamalkumar on 25/12/25.
//

import SwiftUI

struct  GoogleButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "g.circle.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 20))
                
                Text("Continue with Google")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.black)
            }
            .frame(height: 50)
            
            .frame(maxWidth: .infinity) // stretch full width
            .cornerRadius(8)
            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
        }.padding(.leading, 12)
                    .padding(.trailing, 12)
    }
}
    

#Preview {

}
