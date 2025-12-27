//
//  BaseViewModel.swift
//  SampleUI
//
//  Created by kamalkumar on 27/12/25.
//
import Foundation
import SwiftUI
import Combine

class BaseViewModel : ObservableObject{
    
    var objectWillChange: ObservableObjectPublisher
    
    init(objectWillChange: ObservableObjectPublisher) {
        self.objectWillChange = objectWillChange
    }
  
    
    
}
