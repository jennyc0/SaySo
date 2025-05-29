//
//  AppViewModel.swift
//  SaySo
//
//  Created by Jenny Choi on 5/29/25.
//

import Foundation


enum Tab {
    case profile
    case createPost
    case explore
    
    
}
final class AppViewModel: ObservableObject {
    @Published var currTab: Tab = .explore
    
    init() {
        
    }
}
