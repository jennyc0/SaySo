//
//  LoginView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/27/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var signInErrorMessage: String?
    
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
            if let error = signInErrorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            Button("Login") {
                Task {
                    // returns error message if sign in didn't work
                    let result = await authViewModel.signIn(username: email, password: password)
                    if let errorMessage = result {
                        signInErrorMessage = errorMessage
                    } 
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
        .environmentObject(AuthViewModel()) // so preview doesn't crash when testing sign in button 
}
