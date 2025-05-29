//
//  SignUpView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/21/25.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    @State var email = ""
    @State var password = ""
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing])
                .autocapitalization(.none)
            TextField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Sign up") {
                Task {
                    await viewModel.signUp(email: email, password: password)
                }
                
            }
            Button("Already have an account? Log in.", action: {viewModel.authState = .login})
        }
    }
}


#Preview {
    SignUpView()
}
