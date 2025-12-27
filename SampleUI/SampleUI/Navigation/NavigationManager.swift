//
//  NavigationManager.swift
//  SampleUI
//
//  Created by kamalkumar on 27/12/25.
//

import SwiftUI
import Combine


 class NavigationManager: ObservableObject {

     // Must be @Published so SwiftUI can observe changes
     @Published var path = NavigationPath()
     @Published var presentedPage: PageName? // <-- for sheets/fullScreenCover
    
    static let Shared = NavigationManager()
    private init() {}
    func SetPath(_ path: NavigationPath) {
        self.path = path
    }
    func GetPath() -> NavigationPath {
        return self.path
    }
    func ResetPath() {
        self.path = .init()
    }
    
    func moveToSignUpPage()
    {
        self.path.append(PageName.SignUp)
    }
     func moveToPinScreen()
     {
         self.path.append(PageName.PinScreen)
     }
     func present(_ page: PageName)
     {
         presentedPage = page
     }
     func dismiss()
     {
         presentedPage = nil
     }
}
