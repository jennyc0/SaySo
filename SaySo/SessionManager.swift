//
//  SessionManager.swift
//  SaySo
//
//  Created by Jenny Choi on 5/28/25.
//

import Foundation
import Amplify

// different log-in states you can be in
enum AuthState {
    case signUp
    case login
    case confirmCode
    case session
}
final class SessionManager: ObservableObject {
    @Published var authState: AuthState = .login
    
    /*
    
    //see if user is currently signed in
    func getCurrentAuthUser() async {
        _ = Amplify.Auth.getCurrentUser() != nil {
            authState = .session
        } else {
            authState = .login
        }
    }
    
     
     */
    func signIn() {
        
    }
    
    func signOut() {
        
    }
}
