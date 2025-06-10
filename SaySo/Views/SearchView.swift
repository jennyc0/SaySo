//
//  SearchView.swift
//  SaySo
//
//  Created by Jenny Choi on 6/2/25.
//

import SwiftUI

struct SearchView: View {
    
    
    @State private var searchQuery: String = ""
    @State private var matchingUsers: [User] = []
    @State var loadingUsers: Bool = false

    var body: some View {
        VStack {
            TextField("Add friend by username", text: $searchQuery) {
                
            }
            .onChange(of: searchQuery) {
                
            }
            .onSubmit {
                // display username matches 
            }
            
            
            List(matchingUsers) { user in
                
            }
            
        }
        .padding()
        
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
                    .foregroundColor(.gray)
                Text("\(user.username)")
                    .font(.headline)
                Spacer()
                // if current user doesn't have them added, plus symbol
                if ((authViewModel.currentUser?.friends.contains(user.id)) == nil) {
                    Image(systemName: "plus.circle")
                } else if ( true ){
                    
                } else {
                    
                }
                // if request sent, time sybol
                
                // existing friend, check mark symbol
            }
        }
    }
}
#Preview {
    SearchView()
}
