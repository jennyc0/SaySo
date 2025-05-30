//
//  SignUpView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/21/25.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State var errorMessage: String?
    
    @State var email = ""
    @State var username = ""
    @State var password = ""
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing])
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing])
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
            
            TextField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocorrectionDisabled(true)
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            Button("Sign up") {
                if !isValidEmail(email) {
                    errorMessage = "Please enter a valid email"
                } else if !isValidPassword(password) {
                    errorMessage = "Password must be at least eight characters with at least one uppercase letter, one lowercase letter, one number and one special character"
                } else {
                    Task {
                        await viewModel.signUp(email: email, password: password)
                    }
                }
                
            }
            Button("Already have an account? Log in.", action: {viewModel.authState = .login})
        }
    }
}

// returns true if valid email
func isValidEmail(_ email: String) -> Bool{
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
}

// default Amplify rules
func isValidPassword(_ password: String) -> Bool {
    let pattern = #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{8,}$"#
    return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: password)
}
#Preview {
    SignUpView()
}
