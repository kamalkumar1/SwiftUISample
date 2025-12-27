//
//  CommonButton.swift
//  SampleUI
//
//  Created by kamalkumar on 25/12/25.
//

import SwiftUI

struct CommonButton: View {
    var title: String = "Log In"
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.12, green: 0.50, blue: 0.99),
                            Color(red: 0.08, green: 0.38, blue: 0.90)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
        }
    }
}


#Preview {
    CommonButton {
        
    }
}
