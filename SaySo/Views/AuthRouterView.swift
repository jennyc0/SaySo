//
//  AuthRouterView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/28/25.
//

import SwiftUI

struct AuthRouterView: View {
    
    @StateObject var viewModel = AuthViewModel()
    
    var body: some View {
        Group {
            switch viewModel.authState {
            case .login:
                LoginView()
            case .signUp:
                SignUpView()
            case .confirmCode:
                ConfirmationView()
            case .loggedIn:
                NavigationStack {
                    ExploreView()
                }
                
            }
            
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    AuthRouterView()
}
