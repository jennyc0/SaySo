//
//  AuthRouterView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/28/25.
//

import SwiftUI

struct AuthRouterView: View {
    
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var appViewModel = AppViewModel() // used in SignUpView 
    
    var body: some View {
        Group {
            switch authViewModel.authState {
            case .login:
                LoginView()
            case .signUp:
                SignUpView()
            case .confirmCode:
                ConfirmationView()
            case .loggedIn:
                MainAppRouterView()
            }
            
        }
        .environmentObject(authViewModel)
        .environmentObject(appViewModel)
    }
}

#Preview {
    AuthRouterView()
}
