//
//  AppViewModel.swift
//  SaySo
//
//  Created by Jenny Choi on 5/29/25.
//

import Foundation


enum Tab: Hashable {
    case profile
    case createPost
    case explore
}
final class AppViewModel: ObservableObject {
    @Published var currTab: Tab = .explore
    
    init() {
        
    }
    func usernameTaken(_ username: String) async throws -> Bool {
        let exists = try await APIService.shared.usernameExists(username)
        return exists
    }
}
