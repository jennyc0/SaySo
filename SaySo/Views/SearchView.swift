//
//  SearchView.swift
//  SaySo
//
//  Created by Jenny Choi on 6/2/25.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    
    @State private var searchQuery: String = ""
    @State private var matchingUsers: [User] = []
    @State var loadingUsers: Bool = false
    @State var hitEnter: Bool = false

    var body: some View {
            VStack(alignment: .leading){
                TextField("Add friend by username", text: $searchQuery) {
                }
                .padding(.horizontal)
                .padding(.bottom)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled(true)
                .autocapitalization(.none)
                /*.onChange(of: searchQuery) {
                    
                }*/
                .onSubmit {
                    Task {
                        // display username matches
                        var results = await appViewModel.userSearchQuery(searchQuery)
                        results = results.filter {
                            $0.id != authViewModel.currentUser?.id // don't show own name if part of the results
                        }

                        matchingUsers = results
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
                    ForEach(matchingUsers) { user in
                        
                        UserCardView(user: user)
                            .padding(.horizontal)
                    }
                }
                Spacer()
                
            }
            .padding(.top)
        
        
        
    }
}


#Preview {
    SearchView()
        .environmentObject(AppViewModel())
}
