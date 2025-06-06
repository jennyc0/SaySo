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

    /*enum FeedType: String, CaseIterable {
        case explore, friends
    }
    @State private var friendsPosts: [Post] = []
    @State var selectedFeed: FeedType = .explore*/
    
    @State private var publicPosts: [Post] = []
    @State var isLoading: Bool = true

    var body: some View {
        
        /*Picker("Feed Type", selection: $selectedFeed) {
            Text("Explore").tag(FeedType.explore)
            Text("Friends").tag(FeedType.friends)
        }
            .pickerStyle(SegmentedPickerStyle())
        Text("\(selectedFeed)")
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading) */
                
        ScrollView {
            VStack(spacing: 16) {
                if isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if publicPosts.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No public posts yet.")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                } else {
                    ForEach($publicPosts) { post in
                        Divider()
                        PostCardView(post: post)
                    }
                }
            }
        }
        .refreshable {
            (isLoading, publicPosts) = await appViewModel.loadPosts(publicPosts: true)
        }
        .task {
            (isLoading, publicPosts) = await appViewModel.loadPosts(publicPosts: true)
        }
    }
}


// move this to Post file
// how each post will be displayed
struct PostCardView: View {
    @Binding var post: Post
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    @State var voted: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(post.createdAt)
                .font(.caption)
                .foregroundColor(.gray)
            Text(post.text)
                .font(.body)
            Button {
                voted = true
                Task {
                    guard let userId = authViewModel.currentUser?.id else {
                        print("No one currently signed in, can't vote")
                        return
                    }
                    // create a Vote
                    let response = await appViewModel.vote(postId: post.id, userId: userId, voteYes: true)
                    if response {
                        // animation to update the bars to the percentages of votes
                        let newPost: Post = await appViewModel.loadPost(postId: post.id) ?? post
                        self.post = newPost
                    }
                }
                
            } label: {
                if voted {
                    Text(String(post.votedYes))
                } else {
                    Text("Yes")
                        .frame(maxWidth: .infinity)
                        .border(Color.gray)
                    
                }
                
            }
            .disabled(voted)
            
            
            Button{
                voted = true
                Task {
                    guard let userId = authViewModel.currentUser?.id else {
                        print("No one currently signed in, can't vote")
                        return
                    }
                    let response = await appViewModel.vote(postId: post.id, userId: userId, voteYes: false)
                    if response {
                        // animation to update the bars to the percentages of votes
                        let newPost: Post = await appViewModel.loadPost(postId: post.id) ?? post
                        self.post = newPost
                    }
                }
            } label: {
                if voted {
                    Text(String(post.votedNo))
                } else {
                    Text("No")
                        .frame(maxWidth: .infinity)
                        .border(Color.gray)
                }
                
            }
            .disabled(voted)
            
        }
        
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
