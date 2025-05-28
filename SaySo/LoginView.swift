//
//  LoginView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/27/25.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("Email", text: $email)
            SecureField("Password", text: $password)
            
            Button("Login", action: {})
            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
