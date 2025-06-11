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
    //case search
    case profile
}

final class AppViewModel: ObservableObject {
    @Published var friendsPosts: [Post] = []
    @Published var hasLoadedFriends = false
    @Published var isLoadingFriends = true
    
    @Published var publicPosts: [Post] = []
    @Published var hasLoadedExplore = false
    @Published var isLoadingExplore = true

    @Published var hasLoadedProfile = false
    
    @Published var currTab: Tab = .explore
    
    init() {
        
    }
    
    @MainActor
    func loadFriendsIfNeeded() async {
        guard !hasLoadedFriends else {return} // only fetch from backend if neccesary
        isLoadingFriends = true
        var posts: [Post] = []
        (isLoadingFriends, posts) = await loadPosts(publicPosts: false)
        
        //check if user has voted already on the loaded posts
        for i in posts.indices {
            // check if signed in user already voted on this post
            let (voted, vote) = await voteExists(postId: posts[i].id)
            posts[i].userVoted = voted
            posts[i].userVote = vote
        }
        friendsPosts = posts
        hasLoadedFriends = true
    }
    
    @MainActor
    func loadExploreIfNeeded() async {
        guard !hasLoadedExplore else {return} // only fetch from backend if neccesary
        
        isLoadingExplore = true
        var posts: [Post] = []
        
        (isLoadingExplore, posts) = await loadPosts(publicPosts: true)
        print("finished running loadposts")
        print("isLoadingExplore: \(isLoadingExplore)")
        print("posts.count: \(posts.count)")
        //check if user has voted already on the loaded posts
        for i in posts.indices {
            // check if signed in user already voted on this post
            print("checking \(i)th post")
            let (voted, vote) = await voteExists(postId: posts[i].id)
            posts[i].userVoted = voted
            posts[i].userVote = vote
        }
        print("Finished checking if voteexists for all the posts")
        publicPosts = posts
        hasLoadedExplore = true
    }
    
    
    // userId passed from authViewModel.currentUser.userId
    func vote(postId: String, userId: String, voteYes: Bool) async -> Bool {
        do {
            let logVoteSuccess = try await APIService.shared.logVote(postId: postId, userId: userId, voteYes: voteYes)
            let changeVoteCountSuccess = try await APIService.shared.changeVoteCount(postId: postId, voteYes: voteYes, delta: 1)
            
            return logVoteSuccess && changeVoteCountSuccess
        } catch {
            print("failed to log vote: \(error)")
            return false
        }
        // in frontend, change Post w same postId
    }
    func voteExists(postId: String) async -> (Bool, String){
        do {
            let (voteExists, vote) = try await APIService.shared.voteExists(postId: postId)
            print("VoteExists: \(voteExists), vote: \(vote)")
            return (voteExists, vote)
        } catch {
            print("Failed to verify if vote exists: \(error)")
            return (false, "")
        }
    }
    
    func userSearchQuery(_ initialQuery: String) async -> [User] {
        let query = initialQuery.lowercased()
        
        if query.count < 1 {
            return []
        }
        
        do {
            let users = try await APIService.shared.userSearchQuery(query)
            return users
        } catch {
            print("Failed to search for user: \(error)")
            return []
        }
    }
    
    func usernameTaken(_ username: String) async throws -> Bool {
        let usernameLower = username.lowercased()
        let exists = try await APIService.shared.usernameExists(usernameLower)
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
