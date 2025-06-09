//
//  FriendsView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/30/25.
//

import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appViewModel: AppViewModel

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if appViewModel.isLoadingFriends {
                        ProgressView("Loading...")
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else if appViewModel.friendsPosts.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "bubble.left.and.bubble.right")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            Text("No posts yet.")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, minHeight: 300)
                    } else {
                        ForEach(appViewModel.friendsPosts) { post in
                            Divider()
                            PostCardView(post: post)
                        }
                    }
                }
            }
        }
        .navigationTitle("Friends")
        .refreshable {
            (appViewModel.isLoadingFriends, appViewModel.friendsPosts) = await appViewModel.loadPosts(publicPosts: false)
        }
        .task {
            await appViewModel.loadFriendsIfNeeded()
            
        }
    }
        
    
}

#Preview {
    FriendsView()
        .environmentObject(AppViewModel())
        .environmentObject(AuthViewModel())
}
