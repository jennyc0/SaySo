//
//  ExploreView.swift
//  SaySo
//
//  Created by Jenny Choi on 5/19/25.
//  Where all public posts will be displayed

import SwiftUI

let DEV_MODE = false

struct ExploreView: View {
    @State private var posts: [Post] = []
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            VStack {
                Text("Explore")
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                ScrollView {
                    VStack(spacing: 16) {
                        if isLoading {
                            ProgressView("Loading...")
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else if posts.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "bubble.left.and.bubble.right")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                                Text("No public posts yet.")
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, minHeight: 300)
                        } else {
                            
                            ForEach(posts) { post in
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
            self.posts = [  // sample post for layout/testing
                Post(text: "This is a sample post that will take up the whole horizontal space and span multiple lines as needed to demonstrate the layout ", publicPost: true),
                Post(text: "Another placeholder post", publicPost: true)
            ]
            self.isLoading = false
            return
        }
        isLoading = true
        getPosts(publicPost: true) { fetchedPosts in
            DispatchQueue.main.async {
                self.posts = fetchedPosts
                self.isLoading = false
            }
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
