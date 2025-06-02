//
//  AppViewModel.swift
//  SaySo
//
//  Created by Jenny Choi on 5/29/25.
//

import Foundation
import SwiftUI


enum Tab: Hashable {
    case profile
    case createPost
    case explore
    case friends
}
final class AppViewModel: ObservableObject {
    
    @Published var currTab: Tab = .explore
    
    init() {
        
    }
    func usernameTaken(_ username: String) async throws -> Bool {
        let exists = try await APIService.shared.usernameExists(username)
        return exists
    }
    
    // to display posts
    func loadPosts(publicPosts: Bool) async -> (Bool, [Post]) { // returns ifLoading, loadedPosts
        if DEV_MODE {
            print("⚠️ Skipping network call (dev mode)")
            let posts = [  // sample post for layout/testing
                Post(userId: "Jenny-dev", text: "This is a sample post that will take up the whole horizontal space and span multiple lines as needed to demonstrate the layout ", publicPost: true),
                Post(userId: "Jenny-dev", text: "Another placeholder post", publicPost: true),
                Post(userId: "Jenny-dev", text: "first private post! technically a friends only post", publicPost: false),
                                
            ]
            if publicPosts {
                return (false, posts.filter {$0.publicPost})
            } else {
                // user's friends' posts
                return (false, posts.filter {$0.publicPost == false})
            }
        }
        
        do {
            // fetch Public Posts
            if publicPosts {
                let publicLoadedPosts = try await APIService.shared.getPosts(publicPost: true)
                return (false, publicLoadedPosts)
            } else {
                // fetch the user's friends' posts
                let friendsLoadedPosts = try await APIService.shared.getPosts(publicPost: false)
                return (false, friendsLoadedPosts)
            }
            
        } catch {
            print("Failed to load posts: \(error)")
            return (true, [])
        }
        
    }
}
