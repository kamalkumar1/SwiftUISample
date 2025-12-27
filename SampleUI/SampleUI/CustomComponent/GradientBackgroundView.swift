//
//  GradientBackgroundView.swift
//  SampleUI
//
//  Created by kamalkumar on 27/12/25.
//

import SwiftUI

struct GradientBackgroundView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Top gradient section
                Color.clear
                    .frame(maxHeight: .infinity)
                    .background(Color.appGradient)
                    .ignoresSafeArea()
                
                // Bottom white section
                Color.white
                    .frame(maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    GradientBackgroundView()
}

