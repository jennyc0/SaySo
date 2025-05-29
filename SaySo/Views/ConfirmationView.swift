//
//  ConfirmationView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/28/25.
//

import SwiftUI

struct ConfirmationView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    @State var confirmationCode = ""
    var body: some View {
        VStack {
            TextField("Confirmation Code", text: $confirmationCode)
                .padding()
                .border(Color.gray)
            Button("Confirm") {
                Task {
                    await viewModel.confirmSignUp(confirmationCode: confirmationCode)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(confirmationCode == "")
            
        }
        .padding()
        
        
    }
}

#Preview {
    ConfirmationView()
}
