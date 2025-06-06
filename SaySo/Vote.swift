//
//  Vote.swift
//  SaySo
//
//  Created by Jenny Choi on 6/5/25.
//

import Foundation

struct Vote: Codable {
    var postId: String
    var userId: String
    var vote: String // "yes" or "no"
    var delta: Int // 1 or -1 
    
    init(postId: String, userId: String = "", vote: String, delta: Int = 1) {
        self.postId = postId
        self.userId = userId
        self.vote = vote
        self.delta = delta
    }
}
