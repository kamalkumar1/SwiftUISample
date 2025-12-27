//
//  TopView.swift
//  SampleUI
//
//  Created by kamalkumar on 25/12/25.
//

import SwiftUI

struct TopView: View
{
    @State  var referenceFrame: CGRect = .zero
    var body: some View
    {
        VStack(alignment: .center, spacing: 0) {
            
            Image(systemName: "shield.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
                   .frame(height: 24)
                   .frame(maxWidth: 24)
                   .padding(.top, 8)
                   .padding(.bottom, 25)
            
            VStack(spacing: 0){
                Text("Sign in to your")
                    .font(.system(size: 38, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(0)
                Text("Account")
                    .font(.system(size: 38, weight: .semibold))
                    .foregroundColor(.white)
               
            }
            Text("Enter your email and password to login")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .padding(.top, 20)
                .padding(.bottom, 20)
                .background(
                    GeometryReader { geo in Color.clear
                        .preference(key:CommonPreferenceKeys.Frame.self, value: geo.frame(in: .named("Parent")))})
            
        }   
    }
}

#Preview {
    VStack { TopView() } .coordinateSpace(name: "Parent") .background(Color.blue) // just to see the white text
}
