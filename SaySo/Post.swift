//
//  Question.swift
//  SaySo
//
//  Created by Jenny Choi on 5/18/25.
//
import Foundation

struct Post: Codable, Identifiable {
    var id: String // postId
    var text: String
    var votedYes: Int
    var votedNo : Int
    var createdAt: String
    var publicPost: Bool
    var userId: String // who created the post
    var userVoted: Bool? = nil
    var userVote: String? = nil // "yes" or "no"
    
    
    // a post is only created when a new post is published; the user isn't allowed to vote on their own post.
    // therefore userVoted = true, userVote = "selfPost"
    init(userId: String, votedYes: Int = 0, votedNo: Int = 0, text: String, publicPost: Bool) {
        self.id = UUID().uuidString
        self.text = text
        self.votedYes = votedYes
        self.votedNo = votedNo
        self.createdAt = Date().formatted(date: .numeric, time: .complete)
        self.publicPost = publicPost
        self.userId = userId
        self.userVoted = true
        self.userVote = "selfPost"
        
    }
}



