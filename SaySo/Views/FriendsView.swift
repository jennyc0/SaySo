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
    
    @State private var friendsPosts: [Post] = []
    @State var isLoading: Bool = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if friendsPosts.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No public posts yet.")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                } else {
                    ForEach(friendsPosts) { post in
                        Divider()
                        PostCardView(post: post)
                        
                    }
                }
            }
        }
        .refreshable {
            (isLoading, friendsPosts) = await appViewModel.loadPosts(publicPosts: false)
        }
        .task {
            (isLoading, friendsPosts) = await appViewModel.loadPosts(publicPosts: false)
        }
        
    }
}

#Preview {
    FriendsView()
}
