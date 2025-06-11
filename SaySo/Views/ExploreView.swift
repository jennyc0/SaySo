//
//  ExploreView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/19/25.

//  Where all public posts will be displayed

import SwiftUI


struct ExploreView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
               
        ScrollView {
            VStack(spacing: 16) {
                if appViewModel.isLoadingExplore {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if appViewModel.publicPosts.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No posts yet.")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                } else {
                    if appViewModel.hasLoadedExplore {
                        ForEach(appViewModel.publicPosts) { post in
                            Divider()
                            PostCardView(post: post)
                        }
                    }
                    
                }
            }
        }
        .refreshable {
            Task {
                appViewModel.hasLoadedExplore = false
                await appViewModel.loadExploreIfNeeded()
            }
            
        }
        .task {
            await appViewModel.loadExploreIfNeeded()
        }
    }
}



#Preview {
    ExploreView()
        .environmentObject(AppViewModel())
        .environmentObject(AuthViewModel())
}
