//
//  PostCardView.swift
//  SaySo
//
//  Created by Jenny Choi on 6/9/25.
//

import SwiftUI


// how each post will be displayed
struct PostCardView: View {
    @State var post: Post
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
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
        .padding(.horizontal)
        .cornerRadius(10)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}


#Preview {
    //PostCardView()
}
