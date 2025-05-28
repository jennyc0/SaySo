//
//  SignUpView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/21/25.
//

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing])
            TextField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Create Account") {
                
                
            }

            
        }
        
    }
}

#Preview {
    SignUpView()
}
