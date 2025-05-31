//
//  SignUpView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/21/25.
//

import SwiftUI

enum Field: Hashable {
    case email, username, password
}

struct SignUpView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var emailErrorMessage: String?
    @State var usernameErrorMessage: String?
    @State var passwordErrorMessage: String?
    
    @FocusState private var focusedField: Field?
    
    @State var email = ""
    @State var username = ""
    @State var password = ""
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .focused($focusedField, equals: .email)
                .onChange(of: focusedField) { oldState, newState in
                    if oldState == .email && newState != .email && email != "" {
                        if !isValidEmail(email) {
                            // clicked out of email box after clicking it & not entering valid email
                            emailErrorMessage = "Please enter a valid email"
                        }
                    } else if newState == .email {
                        // came back to fix error, don't show error message anymore while they try and fix
                        emailErrorMessage = nil
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing])
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
            if let error = emailErrorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            TextField("Username", text: $username)
                .focused($focusedField, equals: .username)
                .onChange(of: focusedField) { oldState, newState in
                    if oldState == .username && newState != .username && username != "" {
                        // clicked out of box after typing, check if username is unique
                        Task {
                            let valid = await isValidUsername(username)
                            if !valid {
                                usernameErrorMessage = "Username already taken"
                            }
                        }
                    } else if newState == .username {
                        usernameErrorMessage = nil
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing])
                .autocapitalization(.none)
                .autocorrectionDisabled(true)
            if let error = usernameErrorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            SecureField("Password", text: $password)
                .focused($focusedField, equals: .password)
                .onChange(of: focusedField) { oldState, newState in
                    if oldState == .password && newState != .password && password != "" {
                        // check if valid password
                        if !isValidPassword(password) {
                            passwordErrorMessage = "Password must be at least eight characters with at least one uppercase letter, one lowercase letter, one number and one special character"
                        }
                    } else if newState == .password {
                        passwordErrorMessage = nil
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing])
                .autocorrectionDisabled(true)
            if let error = passwordErrorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            Button("Sign up") {
                Task {
                    let valid = await isValidUsername(username)
                    if isValidEmail(email) && isValidPassword(password) && valid {
                        // pass in username too
                        await authViewModel.signUp(email: email, password: password, username: username)
                    }
                }
            }
            Button("Already have an account? Log in.", action: {authViewModel.authState = .login})
        }
    }
    
    // make api call to check if username exists in database
    func isValidUsername(_ username: String) async -> Bool {
        do {
            let exists = try await appViewModel.usernameTaken(username)
            return !exists
        } catch {
            print("checking username existance error: \(error)")
            return false
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
        .environmentObject(AppViewModel())
}
