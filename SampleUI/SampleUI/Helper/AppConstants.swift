//
//  AppConstants.swift
//  SampleUI
//
//  Created by kamalkumar on 27/12/25.
//

import SwiftUI

enum AppConstants {
    // MARK: - PIN Digit Field (Fixed for all screen types)
    static let pinDigitFieldWidth: CGFloat = 70
    static let pinDigitFieldHeight: CGFloat = 70
    static let pinDigitFieldCornerRadius: CGFloat = 16
    static let defaultTextFieldType: PinTextFieldType = .roundCorner
}

// MARK: - PIN Text Field Type Enum
enum PinTextFieldType {
    case rectangle
    case roundCorner
    case withCornerRadius
    
    var cornerRadius: CGFloat {
        switch self {
        case .rectangle:
            return 0
        case .roundCorner:
            return AppConstants.pinDigitFieldCornerRadius
        case .withCornerRadius:
            return AppConstants.pinDigitFieldCornerRadius
        }
    }
    
    var isCircular: Bool {
        switch self {
        case .roundCorner:
            return true // Fully round (Circle)
        case .rectangle, .withCornerRadius:
            return false
        }
    }
}

