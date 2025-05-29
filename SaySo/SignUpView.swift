//
//  SignUpView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/21/25.
//

import SwiftUI

struct SignUpView: View {
    @State var email = ""
    @State var password = ""
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing])
            TextField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Sign up", action: {})
            Button("Already have an account? Log in.", action: {})
        }
    }
}


#Preview {
    SignUpView()
}
