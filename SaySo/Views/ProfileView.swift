//
//  ProfileView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/29/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack {
            Text("My Profile")
            Button("Sign out") {
                Task {
                    await authViewModel.signOut()
                }
            }
        }
        
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
