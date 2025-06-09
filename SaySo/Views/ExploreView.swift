//
//  ExploreView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/19/25.

//  Where all public posts will be displayed

import SwiftUI

let DEV_MODE = false

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
            (appViewModel.isLoadingExplore, appViewModel.publicPosts) = await appViewModel.loadPosts(publicPosts: true)
        }
        .task {
            await appViewModel.loadExploreIfNeeded()
        }
    }
}


// move this to Post file
// how each post will be displayed
struct PostCardView: View {
    @State var post: Post
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appViewModel: AppViewModel
   // @State private var voted: Bool = false
   // @State private var userVote: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(post.createdAt)
                .font(.caption)
                .foregroundColor(.gray)
            Text(post.text)
                .font(.body)
            VoteBar(
                voted: post.userVoted!,
                yesPercentage: post.userVoted! ? Double(post.votedYes) / Double(post.votedYes + post.votedNo) : 0.5,
                votedYes: post.userVote == "yes" ? true : false,
                onVote: { votedYes in
                    Task {
                        guard let userId = authViewModel.currentUser?.id else {
                            print("No one currently signed in, can't vote")
                            return
                        }
                        // create a Vote
                        let success = await appViewModel.vote(postId: post.id, userId: userId, voteYes: votedYes)
                        if success {
                            // load a post with updated vote counts
                            let updatedPost: Post = await appViewModel.loadPost(postId: post.id) ?? post
                            self.post = updatedPost
                            self.post.userVote = votedYes ? "yes" : "no"
                            self.post.userVoted = true
                        }
                    }
                    
                }
            
            )
        }
        /*
        .task {
            // check if user already voted on this post
            let (voted, vote) = await appViewModel.voteExists(postId: post.id)
            self.voted = voted
            self.userVote = vote
        }
        */
        .padding(.horizontal)
        .cornerRadius(10)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    ExploreView()
        .environmentObject(AppViewModel())
        .environmentObject(AuthViewModel())
}
