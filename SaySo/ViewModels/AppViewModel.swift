//
//  AppViewModel.swift
//  SaySo
//
//  Created by Jenny Choi on 5/29/25.
//

import Foundation
import SwiftUI


enum Tab: Hashable {
    case explore
    case friends
    case createPost
    case search
    case profile
}

final class AppViewModel: ObservableObject {
    
    @Published var currTab: Tab = .explore
    
    init() {
        
    }
    // userId passed from authViewModel.currentUser.id
    func vote(postId: String, userId: String, voteYes: Bool) async -> Bool {
        do {
            let logVoteSuccess = try await APIService.shared.logVote(postId: postId, userId: userId, voteYes: voteYes)
            print("logVoteSuccess: \(logVoteSuccess)")
            let changeVoteCountSuccess = try await APIService.shared.changeVoteCount(postId: postId, voteYes: voteYes, delta: 1)
            
            print("changeVoteCountSuccess: \(changeVoteCountSuccess)" )
            return logVoteSuccess && changeVoteCountSuccess
        } catch {
            print("failed to log vote: \(error)")
            return false
        }
        // in frontend, change Post w same postId
    }
    
    //TODO
    func userSearchQuery(_ query: String) async -> [User] {
        if query.count < 1 {
            return []
        }
        
        return []
        
    }
    func usernameTaken(_ username: String) async throws -> Bool {
        let exists = try await APIService.shared.usernameExists(username)
        return exists
    }
    
    func loadPost(postId: String) async -> Post? {
        do {
            let post = try await APIService.shared.getPost(postId: postId)
            return post
        } catch {
            print("Failed to get post: \(error)")
            return nil
        }
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
