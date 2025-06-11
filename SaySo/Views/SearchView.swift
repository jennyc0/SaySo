//
//  SearchView.swift
//  SaySo
//
//  Created by Jenny Choi on 6/2/25.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    
    @State private var searchQuery: String = ""
    @State private var matchingUsers: [User] = []
    @State var loadingUsers: Bool = false
    @State var hitEnter: Bool = false

    var body: some View {
            VStack(alignment: .leading){
                TextField("Add friend by username", text: $searchQuery) {
                }
                .padding(.horizontal)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled(true)
                .autocapitalization(.none)
                /*.onChange(of: searchQuery) {
                    
                }*/
                .onSubmit {
                    Task {
                        // display username matches
                        matchingUsers = await appViewModel.userSearchQuery(searchQuery)
                        hitEnter = true
                    }
                    
                }
                
                if matchingUsers.count == 0 && hitEnter {
                    Spacer().frame(height: 16)
                    Text("No users found.")
                        .foregroundStyle(Color.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                    
                } else {
                    List(matchingUsers) { user in
                        UserCardView(user: user)
                    }
                }
                Spacer()
                
            }
            .padding(.top)
        
        
        
    }
}


struct UserCardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel // stores current user info

    @State var user: User
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 44, height: 44)
                Text("\(user.username)")
                    .font(.headline)
                Spacer()
                
                // existing friend, check mark symbol
                if ((authViewModel.currentUser?.friends.contains(user.userId)) ?? false) {
                    Image(systemName: "checkmark.circle")
                } else if (authViewModel.currentUser?.friendRequestsSent.contains(user.userId) ?? false){
                    // request sent, time sybol
                    Image(systemName: "clock")
                } else {
                    // current user doesn't have them added, plus symbol
                    Image(systemName: "plus.circle")
                }
                
            }
        }
    }
}
#Preview {
    SearchView()
        .environmentObject(AppViewModel())
}
