//
//  LoginView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/27/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing])
                .autocapitalization(.none)
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Login") {
                Task {
                    await authViewModel.signIn(username: email, password: password)
                }
            }
            Button("Don't have an account? Sign up.", action: {authViewModel.authState = .signUp})
            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
