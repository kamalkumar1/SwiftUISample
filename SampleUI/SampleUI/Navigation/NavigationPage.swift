//
//  NavigationPage.swift
//  SampleUI
//
//  Created by kamalkumar on 27/12/25.
//

// Enum for navigation destinations
enum PageName: Hashable, Identifiable {
    case SignUp
    case SignIn
    case PinScreen
    case ForgotPassword
    case Home
    
    var id: String {
        switch self {
        case .SignUp: return "SignUp"
        case .SignIn: return "SignIn"
        case .PinScreen: return "PinScreen"
        case .ForgotPassword: return "ForgotPassword"
        case .Home: return "Home"
        }
    }
}
//#if os(iOS)
//import UIKit
//extension NavigationPage: CaseIterable {
//    var viewController: UIViewController {
//        switch self {
//
//        case .signIn:
//
//        case .signUp:
//
//        case .pinScreen:
//
//
//        case .forgotPassword:
//
//        case .home:
//
//        }
//    }
//}
//#endif // os(iOS)

