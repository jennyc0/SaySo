//
//  Question.swift
//  SaySo
//
//  Created by Jenny Choi on 5/18/25.
//
import Foundation

struct Post: Codable, Identifiable {
    var id: String
    var text: String
    var votedYes: Int
    var votedNo : Int
    var createdAt: String
    var publicPost: Bool
    var userId: String
    
    init(userId: String, text: String, publicPost: Bool) {
        self.id = UUID().uuidString
        self.text = text
        self.votedYes = 0
        self.votedNo = 0
        self.createdAt = Date().formatted(date: .numeric, time: .complete)
        self.publicPost = publicPost
        self.userId = userId
    }
}



