//
//  ExploreView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/19/25.
//  Where all public posts will be displayed

import SwiftUI

let DEV_MODE = false



struct ExploreView: View {
    enum FeedType: String, CaseIterable {
        case explore, friends
    }
    
    @State var selectedFeed: FeedType = .explore
    //@State private var posts: [Post] = [] // used for testing
    @State private var publicPosts: [Post] = []
    @State private var friendsPosts: [Post] = []
    
    @State private var isLoading = true

    var body: some View {
        var displayedPosts: [Post] {
            switch selectedFeed {
                case .explore:
                return publicPosts
            case .friends:
                return friendsPosts
            }
        }
        NavigationView {
            VStack {
                
                Picker("Feed Type", selection: $selectedFeed) {
                    Text("Explore").tag(FeedType.explore)
                    Text("Friends").tag(FeedType.friends)
                }
                    .pickerStyle(SegmentedPickerStyle())
                Text("\(selectedFeed)")
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                ScrollView {
                    VStack(spacing: 16) {
                        if isLoading {
                            ProgressView("Loading...")
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else if displayedPosts.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "bubble.left.and.bubble.right")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                                Text("No public posts yet.")
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, minHeight: 300)
                        } else {
                            ForEach(displayedPosts) { post in
                                Divider()
                                PostCardView(post: post)
                                
                            }
                        }
                    }
                    
                }
                
                .refreshable {await loadPosts()}
                
            }
            .task {
                await loadPosts()
            }
            
            
        }
        
    }

    
    func loadPosts() async {
        if DEV_MODE {
            print("⚠️ Skipping network call (dev mode)")
            let posts = [  // sample post for layout/testing
                Post(text: "This is a sample post that will take up the whole horizontal space and span multiple lines as needed to demonstrate the layout ", publicPost: true),
                Post(text: "Another placeholder post", publicPost: true),
                Post(text: "first private post! technically a friends only post", publicPost: false),
                                
            ]
            self.publicPosts = posts.filter {
                $0.publicPost
            }
            self.friendsPosts = posts.filter {
                $0.publicPost == false
            }
            self.isLoading = false
            return
        }
        isLoading = true
        
        do {
            let fetchedPublicPosts = try await APIService.getPosts(publicPost: true)
            let fetchedFriendsPosts = try await APIService.getPosts(publicPost: false)
            
            self.publicPosts = fetchedPublicPosts
            self.friendsPosts = fetchedFriendsPosts
            self.isLoading = false
            
        } catch {
            print("Failed to load posts: \(error)")
        }
        
    }
}


// move this to Post file
// how each post will be displayed
struct PostCardView: View {
    let post: Post
    var body: some View {
        VStack(alignment: .leading) {
            Text(post.createdAt)
                .font(.caption)
                .foregroundColor(.gray)
            Text(post.text)
                .font(.body)
            Button(action: {}) {
                Text("Yes")
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .cornerRadius(7)
            }
            Button(action: {}) {
                Text("No")
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .cornerRadius(7)
            }
            
        }
        
        .padding(.horizontal)
        .cornerRadius(10)
        .frame(maxWidth: .infinity, alignment: .leading)

    }
    
}


#Preview {
    ExploreView()
}
