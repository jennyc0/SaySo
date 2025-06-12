//
//  UserCardView.swift
//  SaySo
//
//  Created by Jenny Choi on 6/11/25.
//

import SwiftUI

struct UserCardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel // stores current user info
    @EnvironmentObject var appViewModel: AppViewModel // to send friend request
    @State var user: User
    
    
    var hasSentRequest: Bool {
        authViewModel.currentUser?.friendRequestsSent.contains(user.userId) != nil ?? false
    }
    var isFriend: Bool {
        authViewModel.currentUser?.friends.contains(user.userId) != nil ?? false
    }
    var receivedRequest: Bool {
        authViewModel.currentUser?.friendRequestsReceived.contains(user.userId) ?? false
    }
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 44, height: 44)
                Text("\(user.username)")
                    .font(.headline)
                Spacer()
                // received friend request from this user
                if receivedRequest {
                    Button {
                        Task {
                            //accept friend request
                            let updatedUser = await appViewModel.acceptFriendRequest(friendId: user.userId)
                            if let updatedUser {
                                authViewModel.currentUser = updatedUser
                            }
                        }
                    } label: {
                        Text("Accept")
                    }
                } // existing friend, check mark symbol
                else if isFriend {
                    Image(systemName: "checkmark.circle")
                } else if hasSentRequest {
                    // request sent, time symbol
                    Text("Pending")
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray))
                    //Image(systemName: "clock")
                } else {
                    // current user doesn't have them added, plus symbol
                    Button {
                        Task {
                            let updatedUser = await appViewModel.sendFriendRequest(to: user.userId)
                            if let updatedUser {
                                authViewModel.currentUser = updatedUser
                            }
                        }
                    } label: {
                        Text("Add Friend")
                        //Image(systemName: "plus.circle")
                    }
                }
                
            }
        }
    }
}


#Preview {
    //UserCardView()
}
