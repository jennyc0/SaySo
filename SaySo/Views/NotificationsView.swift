//
//  NotificationsView.swift
//  SaySo
//
//  Created by Jenny Choi on 6/11/25.
//

import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    @State var requestUsers: [User] = []
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Notifications")
                .font(.headline)
                
            ForEach(requestUsers) { user in
                UserCardView(user: user)
            }
        }
        .task {
            
            let (requestIds, requestUsers) = await appViewModel.getFriendRequestsReceived(userId: authViewModel.currentUser?.id ?? "")
            // update current user's data member friendRequestsReceived
            authViewModel.currentUser?.friendRequestsReceived = requestIds
            self.requestUsers = requestUsers
            
        }
        .refreshable {
            Task {
                let (requestIds, requestUsers) = await appViewModel.getFriendRequestsReceived(userId: authViewModel.currentUser?.id ?? "")
                // update current user's data member friendRequestsReceived
                authViewModel.currentUser?.friendRequestsReceived = requestIds
                self.requestUsers = requestUsers
            }
            
            
        }
    }
        
}

#Preview {
    NotificationsView()
        .environmentObject(AppViewModel())
        .environmentObject(AuthViewModel())
}
